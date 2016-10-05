function horizontalBarChart(chart, presets) {
    var svg, data, w, h, x, y0, y1, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
    width, height, XAxisKey, keys, datasets, yValue = [], nullValues = [];
    
    //get the DOM Factors(width & Height) where this chart will be rendered
    w = Number(presets.width)
    
    h = Number(presets.height)
    //configs of the svg to be rendered
    margin = {
    top: 15,
    right: 0.20 * w,
    bottom: 0.06 * w,
    left: 0.23 * w
    }
    width = w - margin.left - margin.right;
    height = h - margin.top - margin.bottom;
    
    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
    .range(presets.plotArea.colorPalette);
    
    data = presets.dataset;
    //get the keys of enitre data
    keys = d3.keys(data[0]);
    
    //fetch the XCordinate dynamically or given in presets
    var XAxisKeyraw = presets.dimensions[0].value;
    XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');
    
    // //fetch the y axis keys apart from x-axis
    datasets = presets.measures;
    
    // //overWrite with un-braced data values
    datasets = datasets.map(function(l,i) {
                            return   l.value.replace(/[{}]/g, '');
                            });
    
    //mapping (grouping) the data as required to render
    data.forEach(function(d) {
                 d.values = datasets.map(function(name) {
                                         return {
                                         key: d[XAxisKey],
                                         name: name,
                                         value: +Number(d[name])
                                         };
                                         });
                 });
    
    //initialize scales
    yExtent = data.map(function(d) {
                       return d[XAxisKey];
                       });
    
    //scaling axis
    var arr = [];
    //convert YCordinate datasets Values from strings to Numbers
    for (var i = 0; i < data.length; i++) {
        for (var j = 0; j < data[i].values.length; j++) {
            datasets.map(function(name) {
                         arr.push(Number(data[i].values[j].value)) //arr - grp y-axis values used in scaling while plotting y-axis
                         })
        }
    }
    //legend data manipulation
    var legendSet = presets.measures;
    //overWrite with un-braced data values
    legendSet = legendSet.map(function(l) {
                              return {
                              name: l.name,
                              key: l.value.replace(/[{}]/g, '')
                              }
                              })
    console.log(datasets);
    
    //Initialise AXES
    x = d3.scale.linear().range([0, width]).domain(d3.extent(arr, function(d) { return d; })).nice();
    y0 = d3.scale.ordinal().rangeRoundBands([height, 0], .3).domain(yExtent);
    y1 = d3.scale.ordinal().domain(datasets.reverse()).rangeRoundBands([0, y0.rangeBand()], .2);
    
    if(x.domain()[0] > 0){
        x.domain([0 , x.domain()[1] + x.domain()[1]/arr.length])
    }
    
    //scaling and plotting of axes
    xAxis = d3.svg.axis().scale(x)
    .orient("bottom")
    .tickFormat(d3.format(".2s"))
    .innerTickSize(-height)
    .outerTickSize(0)
    .tickPadding(4)
    .ticks(6);
    yAxis = d3.svg.axis().scale(y0).orient("left").tickSize(1);
    
    //initialize svg
    svg = d3.select("#" + chart).append('svg')
    .attr("width", w)
    .attr("height", h)
    .append("g")
    .attr("transform", "translate(" + margin.left / 1.5 + "," + 0 + ")");
    
    //chart border
    var border = svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("height", height)
    .attr("width", width)
    .style("stroke", "#C2C2C2")
    .style("fill", "none")
    .style("stroke-width", "1");
    
    arr.forEach(function(d) {
                if (d === 0 || d === NaN || isNaN(d)) {
                nullValues.push(d);
                } else {
                yValue.push(d);
                }
                })
    if (yValue.length) {
        chartWrapper = svg.append('g').attr("class", "chartWrapper");
        chartWrapper.append('g').classed('x axis', true)
        chartWrapper.append('g').classed('y axis', true);
        
        //Append x-Axis to svg
        var xaxis = svg.select('.x.axis')
        .attr('transform', 'translate(0 , ' + (height) + ')')
        .call(xAxis.orient('bottom'))
        if(yExtent.length > 4){
            xaxis.selectAll("text")
            .attr("y", 0)
            .attr("x", 9)
            .attr("transform", "rotate(-90)")
            .attr("dx", "-1.2em")
            .attr("dy", ".35em")
            .style("text-anchor", "end");
        }
        var flag, tY;
        yExtent.forEach(function(d){
                        if(d.length > 10){
                        flag = true;
                        tY = -25;
                        }
                        else{
                        flag = false;
                        tY = 0;
                        }
                        })
        
        //Append y-Axis to svg
        var y_axis = svg.select('.y.axis')
        .attr('transform', 'translate(-5,' + tY + ')')
        .call(yAxis)
        
        if(flag){
            y_axis.selectAll(".tick text")
            .call(wrap, y1.rangeBand());
        }
        
        //create groups for each series
        var set = svg.select("g.chartWrapper").selectAll(".dataset")
        .data(data)
        .enter().append("g")
        .attr("class", "dataset")
        .attr("transform", function(d, i) {
              return "translate(0 ," + (y0(d["" + XAxisKey + ""])) + ")";
              })
        
        set.selectAll(".rect")
        .data(function(d, i) {
              return d.values;
              })
        .enter()
        .append("rect")
        .attr("height", y1.rangeBand())
        .attr("x", function(d){ console.log(d)
              if (isNaN(x(d.value))) {
              return x(0);
              } else {
              return x(Math.min(0, d.value));
              }
              })
        .attr("y", function(d) {
              return y1(d.name);
              })
        .attr("width", function(d) {
              if (isNaN(x(d.value))) {
              return x(0);
              } else {
              return Math.abs( x(d.value) - x(0) );
              }
              })
        .style("fill", function(d) {
               return colors(d.name);
               })
        .attr("data-legend", function(d) {
              var attr;
              legendSet.forEach(function(l) {
                                if (l.key === d.name) {
                                attr = l.name
                                }
                                });
              return attr;
              });
        
        
        
        //create a lengend element of <g> and append to svg
        legend = svg.append("g")
        .attr("class", "legend")
        .attr('transform', 'translate(5,50)');
        
        //draw legend factors fetching data from the given elements
        legend.selectAll('rect')
        .data(legendSet)
        .enter()
        .append("g")
        .attr("width", "100")
        .attr("height", "50").attr('transform', 'translate(0,0)')
        .attr("class", "legend-item")
        .append("rect")
        .attr("x", width)
        .attr("y", function(d, i) {
              return i * 15;
              })
        .attr("rx", "2")
        .attr("ry", "2")
        .attr("width", 10)
        .attr("height", 10)
        .style("fill", function(d, i) {
               return colors(d.key)
               })
        legend.selectAll('.legend-item')
        .append("text")
        .attr('x', width + 12)
        .attr('y', function(d, i) {
              return i * 15 + 9;
              })
        .text(function(d, i) {
              return d.name
              });
    } else {
        svg.append("text")
        .attr("x", width / 2)
        .attr("y", height / 2)
        .attr("text-anchor", "middle")
        .style("font-size", "14px")
        .text("NO DATA");
    }
}

function wrap(text, width) {
    text.each(function() {
              var text = d3.select(this),
              words = text.text().split(/\s+/).reverse(),
              word,
              line = [],
              lineNumber = 0,
              lineHeight = 0.8, // ems
              y = text.attr("y"),
              dy = parseFloat(text.attr("dy")),
              tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y+10).attr("dy", dy + "em");
              while (word = words.pop()) {
              line.push(word);
              tspan.text(line.join(" "));
              if (tspan.node().getComputedTextLength() > width) {
              line.pop();
              tspan.text(line.join(" "));
              line = [word];
              tspan = text.append("tspan").attr("x", 0).attr("y", y+10).attr("dy", ++lineNumber * lineHeight + dy + "em").text(word);
              }
              }
              });
}