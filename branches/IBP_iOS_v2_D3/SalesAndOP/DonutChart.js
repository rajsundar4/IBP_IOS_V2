function DonutChart(chart, presets) {
    var svg, data, r, chartWrapper, line, path, margin = {},
        width, height, keys, datasets;

    //get the DOM Factors(width & Height) where this chart will be rendered
    var BBox = d3.select("#" + chart).node().getBoundingClientRect();

    var h = .45 * BBox.width; //Calculated height for window based on width fetched from "BBox"

    //configs of the svg to be rendered
    margin = {
        top: 20,
        right: 0.18 * BBox.width,
        bottom: 40,
        left: 40
    }
    width = BBox.width - margin.left - margin.right,
    height = h - margin.top - margin.bottom;
    r = h/2;

    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
        .range(presets.plotArea.colorPalette);

    data = presets.dataset;

    //fetch the XCordinate dynamically or given in presets
    var XAxisKeyraw = presets.dimensions[0].value;
    XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');

    var dLeg = d3.nest()
                 .key(function(d){return d[XAxisKey] })
                 .entries(data)

    //legend data manipulation
    var legendSet = presets.measures;
    //overWrite with un-braced data values
    legendSet = legendSet.map(function(l) {
        return {
            name: l.name,
            key: l.value.replace(/[{}]/g, '')
        }
    })

    //initialize svg
    svg = d3.select("#" + chart).append('svg')
                                .data([data])
                                .attr("width", BBox.width)
                                .attr("height", h)        
                                .append("g")
                                .attr("transform", "translate(" + (BBox.width/ 3 ) + "," + (h/2 ) + ")");

    chartWrapper = svg.append('g').attr("class", "chartWrapper");     
    chartWrapper.append('g').data(data).enter();

    // svg.append("text")
    //    .attr("text-anchor", "middle")
    //    .attr("class", "donutText")
    //    .text(legendSet[0].name)
    //    .call(wrap, r/2);  

    // declare an arc generator function
    var arc = d3.svg.arc()
                    .outerRadius(r)
                    .innerRadius(r-50);

    var pie = d3.layout.pie()
                .value(function(d){return d.NETDEMAND });

    // select paths, use arc generator to draw
    var arcs = chartWrapper.selectAll(".slice")
                  .data(pie)
                  .enter()
                  .append("g").attr("class", "slice");

    //render arcs based on values
    arcs.append("path")
        .attr("fill", function(d, i){
            return colors(i);
        })
        .attr("d", function (d) { 
            return arc(d);
        })
    //create a lengend element of <g> and append to svg
    legend = svg.append("g")
        .attr("class", "legend")
        .attr('transform', function(d,i){
            return 'translate('+r/5+', ' + r/5 + ')' ;
        });

    //draw legend factors fetching data from the given elements
    legend.selectAll('rect')
        .data(dLeg)
        .enter()
        .append("g")
        .attr("width", "100")
        .attr("height", "50").attr('transform', 'translate(0,0)')
        .attr("class", "legend-item")
        .append("rect")
        .attr("x",  r + margin.left)
        .attr("y", function(d, i) {
            return i * 15;
        })
        .attr("width", 10)
        .attr("height", 10)
        .style("fill", function(d, i) {// console.log(d);
            return colors(i)
        })
    legend.selectAll('.legend-item')
        .append("text")
        .attr('x', r + margin.left + 12)
        .attr('y', function(d, i) {
            return i * 15 + 9;
        })
        .text(function(d, i) {
            return d.key
        });
}

// function wrap(text, width) {
//   text.each(function() {
//     var text = d3.select(this),
//         words = text.text().split(/\s+/).reverse(),
//         word,
//         line = [],
//         lineNumber = 0,
//         lineHeight = 1.1, // ems
//         y = text.attr("y"),
//         dy = parseFloat(text.attr("dy")),
//         tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dy", dy + "em");
//     while (word = words.pop()) {
//       line.push(word);
//       tspan.text(line.join(" "));
//       if (tspan.node().getComputedTextLength() > width) {
//         line.pop();
//         tspan.text(line.join(" "));
//         line = [word];
//         tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
//       }
//     }
//   });
// }