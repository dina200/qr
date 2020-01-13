import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/admin_page_presenters/admin_inventory_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/inventory_table.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';
import 'package:qr/src/presantation/widgets/title_tile.dart';

class AdminInventoryPage extends StatefulWidget {
  static const nameRoute = routes.inventory;

  static PageRoute<AdminInventoryPage> buildPageRoute(Inventory inventory) {
    return MaterialPageRoute<AdminInventoryPage>(
      builder: (context) => _builder(context, inventory),
      settings: RouteSettings(name: nameRoute),
    );
  }

  static Widget _builder(BuildContext context, Inventory inventory) {
    return ChangeNotifierProvider(
      create: (_) => AdminInventoryPagePresenter(inventory),
      child: AdminInventoryPage(),
    );
  }

  @override
  _AdminInventoryPageState createState() => _AdminInventoryPageState();
}

class _AdminInventoryPageState extends State<AdminInventoryPage> {
  AdminInventoryPagePresenter _presenter;

  @override
  Widget build(BuildContext context) {
    _presenter = Provider.of<AdminInventoryPagePresenter>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_presenter.inventory.name),
      ),
      body: LoadingLayout(
        isLoading: _presenter.isLoading,
        child: CustomScrollView(
          slivers: <Widget>[
            _buildTableSliver(),
            _buildStatisticTileSliver(),
            _buildStatisticSliverList(),
          ],
        ),
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
    if (statistic == null) {
      return SliverToBoxAdapter();
    } else if (statistic.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200.0,
          child: Center(
            child: Text(qrLocale.listIsEmpty),
          ),
        ),
      );
    }
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
            leading: Text(stat.dateFormatted),
            title: _buildUserInfo(stat.user),
            trailing: Text(stat.status.status),
          ),
        );
      }, childCount: statistic.length),
    );
  }

  Widget _buildUserInfo(User user) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '${user.name}\n',
        style: Theme.of(context).textTheme.subtitle,
        children: [
          TextSpan(
            text: '${user.email}\n',
            style: Theme.of(context).textTheme.caption,
          ),
          TextSpan(
            text: '${user.phone}',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
