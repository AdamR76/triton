// const findParent = gr => gr.groupid === head.parent;
// const find = ([xHead, ...xs]) => {
// 	if (!xHead) return null;
// 	if (findParent(xHead)) return xHead;
// 	return find(xHead.children ?? []) ?? find(xs);
// };

const arrToObjectData = (arrHeader, arrBody) =>
	arrHeader.reduce(
		(prevValue, curValue, curIndex) => ({ ...prevValue, [curValue]: arrBody[curIndex] }),
		{}
	);

module.exports = rawData => {
	const arrayData = rawData.split(/\r\n|\n/g),
		[stringHeadData, ...arrayBodyData] = arrayData,
		arrayHeadData = stringHeadData.split(','),
		bodyData = arrayBodyData.map(body => body.split(','));

	const data = [];

	for (let idx = 0; idx < bodyData.length; idx++) {
		data.push(arrToObjectData(arrayHeadData, bodyData[idx]));
	}
	return data;
};
