const parser = require('rocketrml');
var fs = require('fs')

const doMapping = async () => {
  try{
    source1 = fs.readFileSync('/data/source1.csv', 'utf8')
    source2 = fs.readFileSync('/data/source2.csv', 'utf8')
    source3 = fs.readFileSync('/data/source3.csv', 'utf8')
    source4 = fs.readFileSync('/data/source4.csv', 'utf8')
    source5 = fs.readFileSync('/data/source5.csv', 'utf8')
    source6 = fs.readFileSync('/data/source6.csv', 'utf8')
    source7 = fs.readFileSync('/data/source7.csv', 'utf8')
    source8 = fs.readFileSync('/data/source8.csv', 'utf8')
    source9 = fs.readFileSync('/data/source9.csv', 'utf8')
    source10 = fs.readFileSync('/data/source10.csv', 'utf8')
    mapping = fs.readFileSync('/mappings/mapping.ttl', 'utf8')
  }catch(e){
    console.log('Error:', e.stack);
  }
  let inputFiles = {
    "/data/source1.csv": source1,
    "/data/source2.csv": source2,
    "/data/source3.csv": source3,
    "/data/source4.csv": source4,
    "/data/source5.csv": source5,
    "/data/source6.csv": source6,
    "/data/source7.csv": source7,
    "/data/source8.csv": source8,
    "/data/source9.csv": source9,
    "/data/source10.csv": source10
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