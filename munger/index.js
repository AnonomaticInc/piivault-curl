const fs = require('fs');
const fp = require('path');

const commander=require('commander');
commander
  .usage('[OPTIONS]...')
  .option('--schemaid <value>', 'PIIVault Passthrough Schema Id')
  .option('--chunksize <value>', 'PIIVault Passthrough ChunkSize')
  .option('--seed <value>', 'PIIVault Passthrough Seed value')
  .option('--infile <value>', 'csv file to read')
  .option('--start <value>', 'data row to start processing from')
  .option('--count <value>', 'number of rows to process')
  .option('--chunk <value>', 'output chunk size')
  .option('--outfile <value>', 'the base output file to write to')
  .option('--format', 'output formatted json')
  .parse(process.argv);

const opts = commander.opts();
console.error(opts);

const csvFilePath=opts.infile;
let jsonFilePath=opts.outfile || null;

const csv=require('csvtojson')
csv()
.fromFile(csvFilePath)
.then((jsonObj)=>{

	const start=parseInt(opts.start,10) || 0;
	const count=parseInt(opts.count,10) || jsonObj.length;
	const chunk=parseInt(opts.chunk,10) || 0;

	if (chunk > 0) {
		let index=0;
		let offset = start;
		while(offset < start+count) {
			let result = {
			    SchemaId: opts.schemaid || "00000000-0000-0000-0000-000000000000",
			    Seed: parseInt(opts.seed, 10) || 0,
			    ChunkSize: parseInt(opts.chunksize,10) || 0,
			    Data: jsonObj.slice(offset,offset+chunk)
			  };

			if (jsonFilePath) {
				let dirname = fp.dirname(jsonFilePath);
				let basename = fp.basename(jsonFilePath);
				let extname = fp.extname(jsonFilePath);

				let outfile = fp.join(dirname||'', (basename||'request')+'.'+index+'.'+(extname || 'json'));

				fs.writeFileSync(outfile, opts.format ? JSON.stringify(result, null, 4) : JSON.stringify(result));
			}
			else {
				console.log(opts.format ? JSON.stringify(result, null, 4) : JSON.stringify(result));
			}

			offset += chunk;
			index += 1;
		}
	}
	else {
		let result = {
		    SchemaId: opts.schemaid || "00000000-0000-0000-0000-000000000000",
		    Seed: parseInt(opts.seed, 10) || 0,
		    ChunkSize: parseInt(opts.chunksize,10) || 0,
		    Data: jsonObj.slice(start,start+count)
		  };

		if (jsonFilePath) {
			fs.writeFileSync(jsonFilePath, opts.format ? JSON.stringify(result, null, 4) : JSON.stringify(result));
		}
		else {
  			console.log(opts.format ? JSON.stringify(result, null, 4) : JSON.stringify(result));
		}
	}

  //console.log(JSON.stringify(result, null, 4));
})
