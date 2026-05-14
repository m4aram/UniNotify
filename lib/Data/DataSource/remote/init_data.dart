import '../../../Framework/Class/crud.dart';
import '../../../liinkapi.dart';

class InitData {
  Crud crud;
  InitData(this.crud);

  load() async {
    return await crud.postData(
      Applink.initLookup,
      {},
    );
  }
}
