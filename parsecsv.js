const fs = require('fs').promises;

const chunk = (arr, size) => {
	const chunked = [];
	while (arr.length) {
		chunked.push(arr.splice(0, size));
	}
	return chunked;
};

const createCSV = items => {
	const itemKeys = Object.keys(items[0]);
	const csv = [
		itemKeys.join(','),
		...items.map(row => itemKeys.map(name => JSON.stringify(row[name])).join(',')),
	].join('\r\n');
	return csv;
};

fs.readFile('nfirscodes.csv', 'utf-8')
	.then(data => data.replace(/"/g, ''))
	.then(data => data.split(/-(.*)/))
	.then(data => chunk(data, 2))
	.then(data => data.map(([key, val]) => [key.replace('\n', '').replace(/\s$/, ''), val]))
	.then(data => data.map(([key, value]) => Object.assign({}, { inc_code: key, inc_desc: value })))
	.then(data => createCSV(data))
	.then(data => fs.writeFile('inc-codes.csv', data))
	.catch(console.log);
