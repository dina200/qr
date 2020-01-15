import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/inventory_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/inventory_table.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';
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

    return LoadingLayout(
      isLoading: _presenter.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_presenter.inventory.name),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            _buildTableSliver(),
            if (_isTakenOrLost()) _buildChangeStatusTileSliver(),
            if (_isTakenOrLost()) _buildChangeStatusButtonSliver(),
            _buildStatisticTileSliver(),
            _buildStatisticSliverList(),
          ],
        ),
      ),
    );
  }

  bool _isTakenOrLost() {
    final status = _presenter.inventory;
    return status.status == InventoryStatus.taken ||
        status.status == InventoryStatus.lost;
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

  Widget _buildChangeStatusTileSliver() {
    return SliverToBoxAdapter(
      child: TitleTile(
        title: qrLocale.changeStatus,
      ),
    );
  }

  Widget _buildChangeStatusButtonSliver() {
    final status = _presenter.inventory;
    String buttonTitle;
    InventoryStatus newInventoryStatus;
    if (status.status == InventoryStatus.taken) {
      buttonTitle = qrLocale.isLost;
      newInventoryStatus = InventoryStatus.lost;
    } else if (status.status == InventoryStatus.lost) {
      buttonTitle = qrLocale.isFound;
      newInventoryStatus = InventoryStatus.taken;
    }
    return SliverToBoxAdapter(
      child: ListTile(
        title: RaisedButton(
          color: Theme.of(context).accentColor,
          child: Text(buttonTitle),
          onPressed: () async =>
          await _onChangeInventoryStatus(newInventoryStatus),
        ),
      ),
    );
  }

  Future<void> _onChangeInventoryStatus(
      InventoryStatus newInventoryStatus) async {
    final isConfirmed = await _showChangeStatusDialog(newInventoryStatus);

    if (isConfirmed) {
      await _presenter.changeInventoryStatus(newInventoryStatus);
    }
  }

  Future<bool> _showChangeStatusDialog(InventoryStatus newInventoryStatus) async {
    return await showDialog(
      context: context,
      builder: (context) {
        String title;
        if (newInventoryStatus == InventoryStatus.lost) {
          title = qrLocale.areYouSureWantMakeItLost;
        } else if (newInventoryStatus == InventoryStatus.taken) {
          title = qrLocale.areYouSureWantMakeItFound;
        }
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.subtitle,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(qrLocale.cancel),
              onPressed: () => Navigator.of(context).pop<bool>(false),
            ),
            FlatButton(
              child: Text(qrLocale.ok),
              onPressed: () => Navigator.of(context).pop<bool>(true),
            ),
          ],
        );
      },
    ) ??
        false;
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
