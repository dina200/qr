import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr/src/domain/entities/inventory.dart';
import 'package:qr/src/domain/entities/user.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/presenters/admin_page_presenters/admins_presenters/admin_inventory_page_presenter.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/inventory_table.dart';
import 'package:qr/src/presantation/widgets/loading_layout.dart';
import 'package:qr/src/presantation/widgets/title_tile.dart';

class AdminInventoryPage extends StatefulWidget {
  static const nameRoute = routes.adminInventory;

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
            if (isFreeOrLost()) _buildChangeStatusTileSliver(),
            if (isFreeOrLost()) _buildChangeStatusButtonSliver(),
            _buildStatisticTileSliver(),
            _buildStatisticSliverList(),
          ],
        ),
      ),
    );
  }

  bool isFreeOrLost() {
    final status = _presenter.inventory;
    return status.status == InventoryStatus.free ||
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
    if (status.status == InventoryStatus.free) {
      buttonTitle = qrLocale.isLost;
      newInventoryStatus = InventoryStatus.lost;
    } else if (status.status == InventoryStatus.lost) {
      buttonTitle = qrLocale.isFound;
      newInventoryStatus = InventoryStatus.free;
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
    final isConfirmed = await _showChoiceRemoveDialog(newInventoryStatus);

    if (isConfirmed) {
      await _presenter.changeInventoryStatus(newInventoryStatus);
    }
  }

  Future<bool> _showChoiceRemoveDialog(InventoryStatus newInventoryStatus) async {
    return await showDialog(
          context: context,
          builder: (context) {
            String title;
            if (newInventoryStatus == InventoryStatus.lost) {
              title = qrLocale.areYouSureWantMakeItLost;
            } else if (newInventoryStatus == InventoryStatus.free) {
              title = qrLocale.areYouSureWantMakeItFree;
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
        title: qrLocale.statistic,
      ),
    );
  }

  Widget _buildStatisticSliverList() {
    final statistic = _presenter.statistic;
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
