import '../models/pc_build.dart';
import 'local_build_generator.dart';

class AiService {
  final _localGen = LocalBuildGenerator();

  PcBuild generateBuild(BuildConfig config) => _localGen.generate(config);
}
