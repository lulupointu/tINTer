import 'package:tinter_backend/database_interface/database_interface.dart';

main() async {
  final TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  tinterDatabase.connection.query(
    """
    
    
    
    """
  );

}