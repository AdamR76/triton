const createObject = require('./readCSV');

const fs = require('fs').promises;

// push into object with count, inc_num and time range
// look at previous entries to see if current time is in previous range
// look ahead from current to see if inc falls in range

const findCommonElement = (array1, array2) => {
	for (let idx = 0; idx < array1.length; idx++) {
		for (let jdx = 0; jdx < array2.length; jdx++) {
			if (array1[idx] === array2[jdx]) {
				return true;
			}
		}
	}
	return false;
};

const createCSV = items => {
	const itemKeys = Object.keys(items[0]);
	const csv = [
		itemKeys.join(','),
		...items.map(row => itemKeys.map(name => JSON.stringify(row[name])).join(',')),
	].join('\r\n');
	return csv;
};

fs.readFile('concurrent_dump.csv', 'utf-8')
	.then(createObject)
	.then(data => {
		const counted = [];
		for (let idx = 0; idx < data.length; idx++) {
			const concurrent = data.filter(row => row.inc_num === data[idx].inc_num);
			if (concurrent.length) {
				const [{ inc_num }] = concurrent;
				if (!counted.some(val => val.inc_num === inc_num))
					counted.push(
						Object.assign(
							{},
							{
								inc_num,
								range: `${concurrent[0].dispatch_time} - ${concurrent[0].clear_time}`,
								add_unit_count: concurrent.map(curr => curr.add_unit).length,
							}
						)
					);
			}
		}
		console.log('counted');
		return counted;
	})
	.then(data => {
		const all = data;
		const filtered = data.filter((row, idx) =>
			all[idx - 1] === undefined
				? row
				: row.add_unit_count.length === 0
				? row
				: all[idx - 1] !== undefined && !findCommonElement(all[idx - 1].add_unit_count, row.add_unit_count)
		);
		console.log('filtered');
		return filtered;
	})
	.then(rows => {
		const freq = {};

		for (let idx = 0; idx < rows.length; idx++) {
			const unit = rows[idx].add_unit_count;
			freq[unit] ? freq[unit] += 1 : freq[unit] = 1;
		}
		const avg = Object.fromEntries(
			Object.entries(freq).map(([key, value]) => [
				Math.round(key),
				Number(parseFloat(value / rows.length).toFixed(8)),
			])
		);
		const avgCSV = createCSV(avg)
		const csv = createCSV([freq]);
		return fs
			.writeFile('concurrency-count.csv', csv)
			.then(() => fs.writeFile('concurrency-percentage.csv', avgCSV));
	});
