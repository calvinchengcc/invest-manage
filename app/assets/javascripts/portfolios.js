window.onload = function () {
	document.getElementById("filter").onsubmit = function (e) {
		var selections = this.querySelectorAll(".selection");
		for (var i = 0; i < selections.length; i++) {
			var s = selections[i];
			var col = s.querySelector("select.col");
			col = col.children[col.selectedIndex].value;
			var op = s.querySelector("select.op");
			op = op.children[op.selectedIndex].value;
			s.querySelector("input").setAttribute("name", "filter[" + col + "][" + op + "]");
		}
	}

	var add = document.getElementById("add");
	var st = document.getElementById("st").textContent;
	var filters = document.querySelector(".filters");
	function addFilter(e) {
		e.preventDefault();
		var d = document.createElement("div");
		d.classList.add("selection");
		d.innerHTML = st;
		d.querySelector(".remove").onclick = function (e) {
			e.preventDefault();
			d.remove();
		}
		filters.appendChild(d);

		return false;
	}

	var sadd = document.getElementById("sadd");
	var sc = document.getElementById("sc").textContent;
	var stocks = document.querySelector(".stocks");
	function addStockFilter(e) {
		e.preventDefault();
		var d = document.createElement("div");
		d.classList.add("sf");
		d.innerHTML = sc;
		d.querySelector(".remove").onclick = function (e) {
			e.preventDefault();
			d.remove();
		}
		stocks.appendChild(d);

		return false;
	}

	var r = document.querySelectorAll(".remove");
	for (var i = 0; i < r.length; i++) {
		r[i].onclick = function (e) {
			e.preventDefault();
			this.parentNode.remove();
		}
	}

	var f = document.getElementById("showfilter");
	var fb = document.querySelector(".filterbox");
	f.onclick = function () {
		fb.style.display = "initial";
	}
	fb.onclick = function (e) {
		if (e.target == fb)
			fb.style.display = "none";
	}
	fb.querySelector("#cancel").onclick = function () {
		fb.style.display = "none";
	}

	add.onclick = addFilter;
	sadd.onclick = addStockFilter;
}
