let  project = new Project('BlockArena');

project.addSources('Sources');
project.addAssets('Assets/**');
project.addDefine('direct_connection');

resolve(project);
