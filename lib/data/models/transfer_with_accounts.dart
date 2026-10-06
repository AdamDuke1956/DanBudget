import '../local/app_database.dart';

class TransferWithAccounts {
  final AccountTransfersTableData transfer;
  final AccountsTableData? fromAccount;
  final AccountsTableData? toAccount;

  const TransferWithAccounts({
    required this.transfer,
    this.fromAccount,
    this.toAccount,
  });
}
