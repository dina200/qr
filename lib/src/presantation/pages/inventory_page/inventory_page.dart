import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/inventory_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/inventory_table.dart';
import 'package:qr/src/presantation/widgets/title_tile.dart';

class InventoryPage extends StatefulWidget {
  static const nameRoute = routes.inventory;

  static PageRoute<InventoryPage> buildPageRoute(Inventory inventory) {
    return MaterialPageRoute<InventoryPage>(
      builder: (context) => _builder(context, inventory),
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context, Inventory inventory) {
    return ChangeNotifierProvider(
      create: (_) => InventoryPagePresenter(inventory),
      child: InventoryPage(),
    );
  }

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<InventoryPage> {
  InventoryPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<InventoryPagePresenter>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_presenter.inventory.name),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _buildTableSliver(),
          _buildStatisticTileSliver(),
          _buildStatisticSliverList(),
        ],
      ),
    );
  }

  Widget _buildTableSliver() {
    return SliverToBoxAdapter(
      child: Center(
        child: InventoryTable(
          inventory: _presenter.inventory,
        ),
      ),
    );
  }

  Widget _buildStatisticTileSliver() {
    return SliverToBoxAdapter(
      child: TitleTile(
        title: qrLocale.userStatistic,
      ),
    );
  }

  Widget _buildStatisticSliverList() {
    final statistic = _presenter.getUserStatistic(_presenter.inventory);
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final stat = statistic[index];
        return DecoratedBox(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: index != statistic.length - 1
                          ? Theme.of(context).dividerColor
                          : Colors.transparent))),
          child: ListTile(
            dense: true,
            leading: Text(stat.dateFormatted),
            trailing: Text(stat.status.status),
          ),
        );
      }, childCount: statistic.length),
    );
  }
}
