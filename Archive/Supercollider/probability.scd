

(
f = { 1.0.rand };
g = { 1.0.rand ** 2 };

p = {|fn, num=1000000|
	var v = (1..(num -1 )).collect({|i| fn.()});
	v;
};

~countArray = {|array, condition|
	var ret = 0;
	array.do{|item| if( condition.(item)) {ret = ret + 1}};
	ret;
};

~between = { | val, f, t|
	(val >= f) && (val < t);
};



~bucket = {|dist|
	var buckets=10;
	var f = 0; //dist.minItem;
    var t = 1; //dist.maxItem;
	var ret = Array.newClear(buckets);
	var bucketSize = (t - f) / (buckets * 1.0);
	bucketSize.postln;

	buckets.do {|i|
		ret[i] = ~countArray.(dist, {|x|  ~between.(x, f + (i  * bucketSize), f + ((i + 1) * bucketSize))});
	   // ret[i] = [f + (i  * bucketSize), f + ((i + 1) * bucketSize)];
	};

	ret;
};


c = v.(g);


y = ~bucket.(c);

y.plot;

)

y
y.size
y.minItem
y.maxItem

c.size



