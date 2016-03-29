window.onload = function () {
	document.getElementById("filter").onsubmit = function (e) {
		var selections = this.querySelectorAll(".selection");
		for (var i = 0; i < selections.length; i++) {
			var s = selections[i];
			var col = s.querySelector("select.col");
			col = col.children[col.selectedIndex].getAttribute("name");
			var op = s.querySelector("select.op");
			op = op.children[op.selectedIndex].getAttribute("name");
			s.querySelector("input").setAttribute("name", "filter[" + col + "][" + op + "]");
			console.log(col, op, s);
		}
		console.log(e, this);
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

	var r = document.querySelectorAll(".remove");
	for (var i = 0; i < r.length; i++) {
		r[i].onclick = function (e) {
			e.preventDefault();
			this.parentNode.remove();
		}
	}

	add.onclick = addFilter;
}
