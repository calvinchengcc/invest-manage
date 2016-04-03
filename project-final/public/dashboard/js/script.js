Element.prototype.removeAllChildren = function () {
	while (this.lastChild)
		this.removeChild(this.lastChild);
}

function App() {
	var load = document.getElementById("pageload");
	this.get();
	this.render();
	load.style.display = "none";
}

App.prototype.get = function () {
	var self = this;
	var req = new XMLHttpRequest();
	req.open("GET", "/users/1.json", false);
	req.onload = function () {
		var data = JSON.parse(req.responseText);
		// self.portfolios = data.owned_portfolios.concat(data.managed_portfolios).map(Portfolio.parse);
		self.portfolios = data.managed_portfolios.map(Portfolio.parse);
	}
	req.send();
}

App.prototype.render = function () {
	var pel = document.getElementById("portfolios");
	pel.removeAllChildren();
	this.portfolios.forEach(function (p) {
		pel.appendChild(p.render());
	});
}

function Portfolio(id, purpose, principal, cash, owner, manager) {
	this.id = id;
	this.purpose = purpose;
	this.principal = principal;
	this.cash = cash;
	this.owner = owner;
	this.manager = manager;

	this.get();
}

Portfolio.parse = function (d) {
	return new Portfolio(d.id, d.purpose, d.principal, d.cash, d.owner.name, d.manager.name);
}

Portfolio.template = function () {
	var i = 0, args = arguments;
	var e = document.createElement("div");
	e.innerHTML = document.getElementById("portfolio").textContent.replace(/%s/g, function () {
		return args[i++];
	});

	return e.children[0];
}

Portfolio.prototype.get = function () {
	var self = this;
	var req = new XMLHttpRequest();
	req.open("GET", "/portfolios/" + this.id + ".json", false);
	req.onload = function () {
		var data = JSON.parse(req.responseText);
		self.holdings = data.holdings.map(Holding.parse);
	}
	req.send();
}

Portfolio.prototype.render = function () {
	var self = this;
	var el = Portfolio.template(this.purpose, this.manager, this.cash);
	el.onclick = function () {
		if (el.classList.contains("selected")) return;

		var view = document.getElementById("view");
		view.style.display = "none";

		var selected = el.parentNode.getElementsByClassName("selected");
		for (var i = 0; i < selected.length; i++) selected[i].classList.remove("selected");
		el.classList.add("selected");

		var hel = document.getElementById("holdings");
		hel.removeAllChildren();
		self.holdings.forEach(function (h) {
			hel.appendChild(h.render());
		});
	}

	return el;
}

function Holding(id, shares, purchase, stock, symbol, name, exchange, price, change, range, yrange, open, vol, avgVol, cap, div, yield, eps, ask, bid) {
	this.id = id;
	this.shares = shares;
	this.purchase = purchase;
	this.stock = stock;
	this.symbol = symbol;
	this.name = name;
	this.exchange = exchange;
	this.price = price;
	this.change = change;

	this.range = range;
	this.yrange = yrange;
	this.open = open;
	this.vol = vol;
	this.avgVol = avgVol || "-";
	this.cap = cap;
	this.div = div || "-";
	this.yield = yield || "-";
	this.eps = eps;
	this.ask = ask;
	this.bid = bid;
}

Holding.parse = function (d) {
	return new Holding(d.id, d.num_shares, d.price, d.stock.id, d.stock.symbol, d.stock.name, d.stock.exchange.code, d.stock.current_price, d.stock.current_change_percent, d.stock.stats.days_range, d.stock.stats.year_range, d.stock.stats.open, d.stock.stats.volume, d.stock.stats.average_daily_volume, d.stock.stats.market_capitalization, d.stock.stats.dividend_share / 4, d.stock.stats.dividend_yield, d.stock.stats.earnings_share, d.stock.stats.ask, d.stock.stats.bid);
}

Holding.template = function () {
	var i = 0, args = arguments;
	var e = document.createElement("div");
	e.innerHTML = document.getElementById("holding").textContent.replace(/%s/g, function () {
		return args[i++];
	});

	return e.children[0];
}

Holding.prototype.render = function () {
	var self = this;
	var changeClass = this.change[0] == "-" ? "neg" : "pos";
	var el = Holding.template(this.symbol, this.name, changeClass, this.change, this.price);
	el.onclick = function () {
		var gel = document.getElementById("graph");
		var load = document.getElementById("graphload");
		gel.style.display = "none";
		gel.removeAllChildren();
		load.style.display = "flex";

		var req = new XMLHttpRequest();
		req.open("GET", "/stocks/" + self.stock + ".json", true);
		req.onload = function () {
			var data = JSON.parse(req.responseText);
			var graph = new Graph(data.historical_price_365d);
			load.style.display = "none";
			gel.style.display = "initial";
			graph.render();
		}
		req.send();

		var selected = el.parentNode.getElementsByClassName("selected");
		for (var i = 0; i < selected.length; i++) selected[i].classList.remove("selected");
		el.classList.add("selected");

		var view = document.getElementById("view");
		view.style.display = "initial";
		document.getElementById("symbol").innerText = self.symbol;
		document.getElementById("name").innerText = self.name;
		document.getElementById("change").innerText = self.change;
		document.getElementById("change").classList.remove("neg");
		document.getElementById("change").classList.remove("pos");
		document.getElementById("change").classList.add(self.change[0] == "-" ? "neg" : "pos");
		document.getElementById("price").innerText = "$" + self.price;

		document.getElementById("range").innerText = self.range;
		document.getElementById("52week").innerText = self.yrange;
		document.getElementById("open").innerText = self.open;
		document.getElementById("vol").innerText = self.vol + " / " + self.avgVol;
		document.getElementById("cap").innerText = self.cap;
		document.getElementById("div").innerText = self.div + "/" + self.yield;
		document.getElementById("eps").innerText = self.eps;
		document.getElementById("ask").innerText = self.ask;
		document.getElementById("bid").innerText = self.bid;
	}

	return el;
}

function Graph(data) {
	this.data = data;
}

Graph.prototype.render = function () {
	var svg = d3.select("#graph");
	svg.selectAll("*").remove();

	var width = svg.node().getBoundingClientRect().width;
	var height = svg.node().getBoundingClientRect().height - 30;

	var df = d3.time.format("%b %d");

	var x = d3.scale.linear().range([0, width]);
	var y = d3.scale.linear().range([height, 0]);
	var xa = d3.svg.axis().scale(x).orient("bottom").tickFormat(function (d) {
		return df(new Date(data[d].date));
	});
	var ya = d3.svg.axis().scale(y).orient("right").ticks(6);

	var line = d3.svg.line()
		.x(function (d, i) { return x(i); })
		.y(function (d) { return y(d.price); });

	var data = this.data.map(function (d) {
		return {
			price: d.price,
			date: new Date(d.date)
		};
	}).reverse();

	x.domain(d3.extent(data, function (d, i) {
		return i;
	}));
	y.domain(d3.extent(data, function (d) {
		return d.price;
	}));

	svg.append("path").datum(data).attr({
		class: "line",
		d: line,
		transform: "translate(0,0)"
	});
	svg.append("g").call(ya).attr({
		class: "y axis",
		transform: "translate(" + (width + 10) + ", 0)"
	});
	svg.append("g").call(xa).attr({
		class: "x axis",
		transform: "translate(0," + (height + 10) + ")"
	});
}

window.onload = function () {
	new App();
}
