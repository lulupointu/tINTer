import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';

main() async {
  final TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();


  final RelationsStatusScolaireTable relationsStatusScolaireTable =
  RelationsStatusScolaireTable(database: tinterDatabase.connection);

  // Removing old function
  await tinterDatabase.connection.query("DROP TRIGGER IF EXISTS relation_status_scolaire_check;");
  await tinterDatabase.connection.query("DROP FUNCTION IF EXISTS relation_status_scolaire_check;");

  // New funcion
  final String createConstraintFunctionQuery = """
    CREATE FUNCTION relation_status_scolaire_check() RETURNS trigger AS \$relation_status_scolaire_check\$
    DECLARE
      \"otherStatus\" Text;
    BEGIN
    
        SELECT \"statusScolaire\" INTO \"otherStatus\" FROM ${RelationsStatusScolaireTable.name} 
            WHERE login=OLD.\"otherLogin\" AND \"otherLogin\"=OLD.login;
            
            
        IF NEW.\"statusScolaire\" = 'ignored' THEN
          
          IF \"otherStatus\" = 'askedBinome' 
            OR \"otherStatus\" = 'acceptedBinome' 
            OR \"otherStatus\" = 'refusedBinome' 
            THEN
            UPDATE ${RelationsStatusScolaireTable.name} SET \"statusScolaire\"='liked' WHERE login=OLD.\"otherLogin\" AND \"otherLogin\"=OLD.login;
            DELETE FROM ${BinomePairsProfilesTable.name} WHERE \"login\"=NEW.login OR \"otherLogin\"=NEW.login;
          END IF;
          
          RETURN NEW;
        END IF;
            
        IF OLD.\"statusScolaire\" = 'none' AND NEW.\"statusScolaire\" = 'liked' THEN
          RETURN NEW;
        END IF;
            
        IF OLD.\"statusScolaire\" = 'ignored' AND NEW.\"statusScolaire\" = 'liked' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"statusScolaire\" = 'liked' AND \"otherStatus\" = 'liked' AND NEW.\"statusScolaire\" = 'askedBinome' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"statusScolaire\" = 'liked' AND \"otherStatus\" = 'askedBinome' AND
          (NEW.\"statusScolaire\" = 'acceptedBinome' OR NEW.\"statusScolaire\" = 'refusedBinome') THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"statusScolaire\" = 'askBinome' AND \"otherStatus\" = 'liked' AND NEW.\"statusScolaire\" = 'liked' THEN
          RETURN NEW;
        END IF;
        
        RAISE EXCEPTION 'Status % cannot be changed to % (the other \"statusScolaire\" is %).', 
          OLD.\"statusScolaire\", NEW.\"statusScolaire\", \"otherStatus\"
          USING errcode='invalid_parameter_value';
    END;
    \$relation_status_scolaire_check\$ LANGUAGE plpgsql;
    """;

  // Function trigger
  final String applyTableConstraintQuery = """
    CREATE TRIGGER relation_status_scolaire_check BEFORE UPDATE ON ${RelationsStatusScolaireTable.name}
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION relation_status_scolaire_check();
    """;

  // Add new function
  await tinterDatabase.connection.query(createConstraintFunctionQuery);

  // Add function trigger
  await tinterDatabase.connection.query(applyTableConstraintQuery);

  tinterDatabase.close();
}
