const parser = require('rocketrml');
var fs = require('fs')

const doMapping = async () => {
  try{
    data = fs.readFileSync('/data/data.csv', 'utf8')
    mapping = fs.readFileSync('/mappings/mapping.ttl', 'utf8')
  }catch(e){
    console.log('Error:', e.stack);
  }
  let inputFiles = {
    "/data/data.csv": data
  };
  const options = {
    toRDF: true,
    verbose: true,
    xmlPerformanceMode: false
  };
  const result = await parser.parseFileLive(mapping, inputFiles, options).catch((err) => { console.log(err); });
  fs.appendFile('/results/output.nt', result, function (err) {
    if (err) throw err;
    console.log('Saved!');
  });
};

doMapping();