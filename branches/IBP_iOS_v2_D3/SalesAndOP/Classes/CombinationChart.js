function CombinationChart(chart, presets) {
    var svg, data, x, y, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
    width, height, XAxisKey, keys, datasets, barSet = [],
    lineSet = [],lineSet1 = [],
    arr = [],
    yValue = [],
    nullValues = [];;
    
    ///get the DOM Factors(width & Height) where this chart will be rendered
    w = Number(presets.width)
    
    h = Number(presets.height)
    //configs of the svg to be rendered
    margin = {
    top: 15,
    right: 0.20 * w,
    bottom: 0.08 * w,
    left: 0.18 * w
    }
    width = w - margin.left - margin.right;
    height = h - margin.top - margin.bottom;
    
    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
    .range(presets.plotArea.colorPalette);
    
    data = presets.dataset;
    
    //fetch the XCordinate dynamically or given in presets
    for (var i = 0; i <= presets.dimensions.length - 1; i++) {
        if (presets.dimensions[i].axis === 1) {
            XAxisKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }
        if (presets.dimensions[i].axis === 2) {
            seriesKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }
    }
    
    //legend data manipulation
    legendSet = presets.measures;
    //overWrite with un-braced data values
    legendSet = legendSet.map(function(l, i) {
                              if (i === 0) {
                              return {
                              name: l.name,
                              key: l.value.replace(/[{}]/g, ''),
                              type: "Bar"
                              }
                              }
                              else if (i === 1 ) {
                              return {
                              name: l.name,
                              key: l.value.replace(/[{}]/g, ''),
                              type: "Line"
                              }
                              }
                              else if (i === 2 ) {
                              return {
                              name: l.name,
                              key: l.value.replace(/[{}]/g, ''),
                              type: "Line"
                              }
                              }
                              })
    
    data.map(function(d, i) {
             arr.push(Number(d[legendSet[0]["key"]]), Number(d[legendSet[1]["key"]]));
             if(isNaN(Number(d[legendSet[0]["key"]]))){
             barSet[i] = {
             key: legendSet[0]["key"],
             mkey: d[XAxisKey],
             value: ""
             }
             }
             else{
             barSet[i] = {
             key: legendSet[0]["key"],
             mkey: d[XAxisKey],
             value: +d[legendSet[0]["key"]]
             }
             }
             
             if(isNaN(Number(d[legendSet[1]["key"]]))){
             lineSet[i] = {
             key: legendSet[1]["key"],
             mkey: d[XAxisKey],
             value: "null"
             }
             }
             else{
             lineSet[i] = {
             key: legendSet[1]["key"],
             mkey: d[XAxisKey],
             value: +d[legendSet[1]["key"]]
             }
             }
             if(legendSet.length>2){
             arr.push(Number(d[legendSet[2]["key"]]));
             if(isNaN(Number(d[legendSet[2]["key"]]))){
             lineSet1[i] = {
             key: legendSet[2]["key"],
             mkey: d[XAxisKey],
             value: "null"
             }
             }
             else{
             lineSet1[i] = {
             key: legendSet[2]["key"],
             mkey: d[XAxisKey],
             value: +d[legendSet[2]["key"]]
             }
             }
             }
             })
    
    //initialize scales
    xExtentraw = data.map(function(d) {
                          return d[XAxisKey];
                          });
    
    Array.prototype.contains = function(v) {
        for (var i = 0; i < this.length; i++) {
            if (this[i] === v) return true;
        }
        return false;
    };
    
    Array.prototype.unique = function() {
        var arr = [];
        for (var i = 0; i < this.length; i++) {
            if (!arr.contains(this[i])) {
                arr.push(this[i]);
            }
        }
        return arr;
    }
    xExtent = xExtentraw.unique();
    
    x = d3.scale.ordinal().rangeRoundBands([0, width]).domain(xExtent); //Actual x-Axis Scale
    y = d3.scale.linear().range([height, 20]).domain(d3.extent(arr, function(d) { return d; })).nice(); //y-Axis BAR Scale
    
    if(y.domain()[0] > 0){
        y.domain([0,y.domain()[1]]);
    }
    //initialize axis and formatting
    xAxis = d3.svg.axis().orient('bottom');
    yAxis = d3.svg.axis().orient('left');
    var yFormat = d3.format('.2s');
    
    //initialize svg
    svg = d3.select("#" + chart).append('svg')
    .attr("width", w)
    .attr("height", h)
    .append("g")
    .attr("transform", "translate(" + margin.left / 2 + "," + margin.top + ")");
    
    //chart border
    svg.append("rect")
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
    if (yValue.length) {chartWrapper = svg.append('g').attr("class", "chartWrapper");
        chartWrapper.append('g').classed('x axis', true)
        chartWrapper.append('g').classed('y axis', true);
        
        //Axis Ticks
        var evenOnes = [];
        function splitArray(candid) {
            for(var i=0; i<candid.length; i++)
                if(i % 2 == 0 ){
                    evenOnes.push(candid[i]);
                }
        }
        
        splitArray(xExtent);
        if(xExtent.length > 6){
            xAxis.tickValues(evenOnes);
        }
        
        xAxis.scale(x).tickSize(3);
        yAxis.scale(y)
        .tickFormat(yFormat)
        .innerTickSize(-width)
        .outerTickSize(0)
        .tickPadding(4)
        .ticks(4);
        
        //Append x-Axis to svg
        var xaxiz = svg.select('.x.axis')
        .attr('transform', 'translate(0,' + (height) + ')')
        .call(xAxis);
        if(evenOnes.length > 6){
            xaxiz.selectAll("text")
            .attr("y", 0)
            .attr("x", 9)
            .attr("transform", "rotate(-30)")
            .attr("dx", "-1.2em")
            .attr("dy", ".35em")
            .style("text-anchor", "end");
        }
        
        //Append y-Axis to svg
        svg.select('.y.axis')
        .call(yAxis);
        
        var set = svg.select("g.chartWrapper").selectAll(".dataset")
        .data(barSet)
        .enter().append("g")
        .attr("class", "dataset")
        
        //create rect and render y-values.
        set.append("rect")
        .attr("width", x.rangeBand() / 2)
        .attr("x", function(d) {
              return x(d["mkey"]) + 10;
              })
        .attr("y", function(d) {
              if (isNaN(y(d.value))) {
              return y(0);
              } else {
              return d.value < 0 ? y(0) : y(d.value);
              }
              })
        .attr("height", function(d) {
              if (isNaN(y(d.value))) {
              return 0;
              } else {
              return Math.abs( y(d.value) - y(0) );
              }
              
              })
        .style("fill", function(d, i) {
               return colors(d.key);
               })
        .attr("data-legend", function(d) {
              var attr;
              legendSet.forEach(function(l) {
                                if (l.key === d.name) {
                                attr = l.name
                                }
                                });
              return attr;
              })
        // Line path calulater
        var lineGen = d3.svg.line()
        .x(function(d) {
           return x(d.mkey) + x.rangeBand() / 2;
           })
        .y(function(d) {
           if( !(d.value == NaN || isNaN(d.value))){
           return  y(d.value)
           }
           });
        
        
        chartWrapper.append('path')
        .datum(lineSet)
        .attr("class", "path")
        .attr('stroke', function(d, i) {
              return colors(i)
              })
        .attr('stroke-width', 2)
        .attr('fill', 'none')
        .attr('d', lineGen)
        .attr("data-legend", function(d) {
              var attr;
              legendSet.forEach(function(l) {
                                if (l.key === d.mkey) {
                                attr = l.name
                                }
                                });
              return attr;
              });
        
        if(legendSet.length > 2) {
            chartWrapper.append('path')
            .datum(lineSet1)
            .attr("class", "path")
            .attr('stroke', function(d, i) {
                  return colors(2)
                  })
            .attr('stroke-width', 2)
            .attr('fill', 'none')
            .attr('d', lineGen)
            .attr("data-legend", function(d) {
                  var attr;
                  legendSet.forEach(function(l) {
                                    if (l.key === d.key) {
                                    attr = l.name
                                    }
                                    });
                  return attr;
                  });
        }
        
        
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
        .each(function(d, i) {
              if (i === 0) {
              d3.select(this)
              .append("rect")
              .attr("x", width)
              .attr("y", function(d, j) {
                    return i * 15;
                    })
              .attr("rx", 2)
              .attr("ry", 2)
              .attr("width", 10)
              .attr("height", 10)
              .style("fill", colors(d.key))
              }
              if (i === 1) {
              d3.select(this)
              .append("circle")
              .attr("x", width)
              .attr("y", function(a, j) {
                    return i * 15;
                    })
              .attr("r", 5)
              .attr("cx", width + 5)
              .attr("cy", function(a) {
                    return 5 + i * 15;
                    })
              .style("fill", colors(0))
              }
              if(i === 2){
              d3.select(this)
              .append("circle")
              .attr("x", width)
              .attr("y", function(a, j) {
                    return i * 15;
                    })
              .attr("r", 5)
              .attr("cx", width + 5)
              .attr("cy", function(a) {
                    return 5 + i * 15;
                    })
              .style("fill", colors(2))
              }
              });
        
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