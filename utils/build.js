import 'dotenv/config';
import reflect from '../node_modules/@alumna/reflect/dist/reflect.es.js';
import { zip } from 'zip-a-folder';
import fs from "node:fs"

/**
 * Helper method for updating the plugin in the plugins folder with the files in src.
 */
async function UpdatePlugin() {
  const { res, err } = await reflect({
    src: 'src/',
    dest: process.env.PLUGIN_PATH,
  });

  if (err) {
    console.log(res);
  }
}

/**
 * Helper method for creating a zip for the plugin.
 */
async function BuildPlugin() {
  const version = fs.readFileSync("./version.txt", 'utf-8');
  await zip('./src', `./builds/CompanionsCompanion v${version}.zip`, { destPath: 'CompanionsCompanion/' });
}

switch (process.env.ENVIRONMENT) {
  case 'deploy':
    BuildPlugin();
    break;

  // Development
  default:
    UpdatePlugin();
    break;
}
