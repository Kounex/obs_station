import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../../../models/enums/log_level.dart';
import '../../../../shared/animator/order_button.dart';
import '../../../../shared/general/base_card.dart';
import '../../../../shared/general/cupertino_dropdown.dart';
import '../../../../shared/general/date_range/date_range.dart';
import '../../../../stores/views/logs.dart';

class LogFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LogsStore logsStore = GetIt.instance<LogsStore>();

    return BaseCard(
      topPadding: 12.0,
      bottomPadding: 12.0,
      child: Observer(
        builder: (_) {
          return Column(
            children: [
              DateRange(
                selectedFromDate: logsStore.fromDate,
                updateFromDate: (date) => logsStore.setFromDate(date),
                selectedToDate: logsStore.toDate,
                updateToDate: (date) => logsStore.setToDate(date
                    ?.add(Duration(days: 1))
                    .subtract(Duration(milliseconds: 1))),
              ),
              SizedBox(height: 12.0),
              Row(
                children: [
                  Flexible(
                    child: CupertinoDropdown<LogLevel>(
                      value: logsStore.logLevel,
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text('All'),
                        ),
                        ...LogLevel.values.map(
                          (logLevel) => DropdownMenuItem(
                            value: logLevel,
                            child: Text(logLevel.name),
                          ),
                        ),
                      ],
                      onChanged: (logLevel) => logsStore.setLogLevel(logLevel),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  SizedBox(
                    width: 72.0,
                    child: CupertinoDropdown<AmountLogEntries>(
                      value: logsStore.amountLogEntries,
                      items: [
                        ...AmountLogEntries.values.map(
                          (amount) => DropdownMenuItem(
                            value: amount,
                            child: Text(amount.number.toString()),
                          ),
                        ),
                        DropdownMenuItem(
                          value: null,
                          child: Text('All'),
                        ),
                      ],
                      onChanged: (amount) =>
                          logsStore.setAmountLogEntries(amount),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  OrderButton(
                    order: logsStore.filterOrder,
                    toggle: logsStore.toggleFilterOrder,
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
