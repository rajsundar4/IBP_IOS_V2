function lineChart(chart, presets) {
    var svg, data, x0, x1, y, w, h, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
    width, height, XAxisKey, SeriesKey, legendSet, keys, datasets = [], data = [], arr = [], rawArr = [], yValue = [],
    nullValues = [];
    
    //get the DOM Factors(width & Height) where this chart will be rendered
    w = Number(presets.width)
    
    h = Number(presets.height)
    //configs of the svg to be rendered
    margin = {
    top: 15,
    right: 0.25 * w,
    bottom: 0.18 * w,
    left: 0.10 * w
    }
    width = w - margin.left - margin.right,
    height = h - margin.top - margin.bottom;
    
    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
    .range(presets.plotArea.colorPalette);
    
    rawdata = presets.dataset;
    //get the keys of enitre data
    keys = d3.keys(rawdata[0]);
    
    //fetch the XCordinate dynamically or given in presets
    for (var i = 0; i <= presets.dimensions.length - 1; i++) {
        if (presets.dimensions[i].axis === 1) {
            var XAxisKeyraw = presets.dimensions[i].value;
            XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');
        }
        if (presets.dimensions[i].axis === 2) {
            var seriesKeyraw = presets.dimensions[i].value;
            SeriesKey = seriesKeyraw.replace(/[{}]/g, '');
        }
        
    }
    //fetch the y axis keys apart from x-axis
    
    if (SeriesKey) { // if a series key i.e, axis : 2 is specified in data then
        keys.map(function(key) {
                 if (key !== XAxisKey && key !== SeriesKey) {
                 datasets.push(key);
                 } else {
                 return;
                 }
                 });
        
        //create an array of all values to use on y-axis scale to range specification
        datasets.map(function(name) {
                     rawdata.map(function(d, i) {
                                 arr.push(d[name]);
                                 });
                     });
        
        data = d3.nest()
        .key(function(d) {
             return d[SeriesKey];
             })
        .key(function(d) {
             return d[XAxisKey]
             })
        .entries(rawdata);
        
        data.map(function(d) {
                 d.values.forEach(function(v, i) {
                                  return d.values[i] = datasets.map(function(name) {
                                                                    rawArr.push(Number(v.values[0][name]));
                                                                    return {
                                                                    key: v["key"],
                                                                    name: v.values[0][SeriesKey],
                                                                    value: +v.values[0][name]
                                                                    };
                                                                    })
                                  })
                 })
        
        legendSet = data.map(function(d, i) {
                             return {
                             key: d["key"],
                             name: d["key"]
                             }
                             })
    } else { //if no series Key specified
        
        datasets = d3.keys(rawdata[0]).filter(function(key) { //filter the x-axis
                                              if (SeriesKey) {
                                              return key !== XAxisKey || key !== SeriesKey;
                                              } else {
                                              return key !== XAxisKey;
                                              }
                                              });
        
        //create an array of all values to use on y-axis scale to range specification
        datasets.map(function(name) {
                     rawdata.map(function(d, i) {
                                 arr.push(d[name]);
                                 });
                     });
        
        datasets.map(function(name, i) { //grouping the data if only axis :1 is given
                     return data[i] = {
                     key: name,
                     values: rawdata.map(function(d, i) {
                                         rawArr.push(Number(d[name]));
                                         return {
                                         key: d[XAxisKey],
                                         name: name,
                                         value: +d[name]
                                         };
                                         })
                     }
                     });
        
        //legend data manipulation
        legendSet = presets.measures;
        //overWrite with un-braced data values
        legendSet = legendSet.map(function(l) {
                                  return {
                                  name: l.name,
                                  key: l.value.replace(/[{}]/g, ''),
                                  color: colors(l.value.replace(/[{}]/g, ''))
                                  }
                                  })
    }
    
    //initialize scales
    xExtentraw = rawdata.map(function(d) {
                             return d["" + XAxisKey + ""];
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
    
    //scaling axis
    x0 = d3.scale.ordinal().rangeRoundBands([0, width], 0.3).domain(xExtent); //Actual x-Axis Scale
    x1 = d3.scale.ordinal().domain(legendSet).rangeRoundBands([0, x0.rangeBand()], 0.1); //Series Scaling on X-Axis
    y = d3.scale.linear().domain(d3.extent(rawArr, function(d) { return d; })).range([height - 10, 10]); //y-Axis Scale
    
    //initialize axis and formatting
    xAxis = d3.svg.axis().orient('bottom');
    yAxis = d3.svg.axis().orient('left');
    var yFormat = d3.format('.1s');
    
    //initialize svg
    svg = d3.select("#" + chart).append('svg')
    .attr("width", w)
    .attr("height", h)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
    //chart border
    svg.append("rect")
    .attr("x", 0)
    .attr("y", 0)
    .attr("height", height)
    .attr("width", width)
    .style("stroke", "#C2C2C2")
    .style("fill", "none")
    .style("stroke-width", "1");
    
    rawArr.forEach(function(d) {
                   if (d === 0 || d === NaN || isNaN(d)) {
                   nullValues.push(d);
                   } else {
                   yValue.push(d);
                   }
                   })
    if (yValue.length) {
        chartWrapper = svg.append('g').attr("class", "chartWrapper");
        chartWrapper.append('g').classed('x axis', true);
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
        if(xExtent.length > 8){
            xAxis.tickValues(evenOnes);
        }  
        
        xAxis.scale(x0).tickSize(3);
        yAxis.scale(y).tickSize(1)
        .tickFormat(yFormat)
        .innerTickSize(-width)
        .outerTickSize(0)
        .tickPadding(4)
        .ticks(5);
        
        //Append x-Axis to svg
        svg.select('.x.axis')
        .attr('transform', 'translate(0,' + (height) + ')')
        .call(xAxis)
        .selectAll("text")
        .attr("y", 0)
        .attr("x", 9)
        .attr("transform", "rotate(-90)")
        .attr("dx", "-1.2em")
        .attr("dy", ".35em")
        .style("text-anchor", "end");
        
        //Append y-Axis to svg
        svg.select('.y.axis')
        .call(yAxis);
        
        var lineGens = d3.svg.line()
        .x(function(d) {
           return x0(d[0].key);
           })
        .y(function(d) {
           if( d[0].value == NaN || isNaN(d[0].value)){
           return 0;
           }
           else {
           return y(d[0].value)
           }
           });
        
        var lineGen = d3.svg.line()
        .x(function(d) {
           return x0(d.key);
           })
        .y(function(d) {
           if( d.value == NaN || isNaN(d.value)){
           return 0;
           }
           else {
           return y(d.value)
           }
           });
        
        data.forEach(function(d, i) {
                     if (SeriesKey) {
                     chartWrapper.append('path')
                     .attr("class", "path")
                     .attr('stroke', colors(d.key))
                     .attr('stroke-width', 2)
                     .attr('fill', 'none')
                     .attr('d', lineGens(d.values))
                     .attr("data-legend", d.key);
                     d.values.forEach(function(a) {
                                      chartWrapper.append("circle")
                                      .attr('fill', colors(d.key))
                                      .attr('stroke', colors(d.key))
                                      .attr("r", 2)
                                      .attr("cx", function() {
                                            return x0(a[0].key)
                                            })
                                      .attr("cy", function() {
                                            if( a[0].value == NaN || isNaN(a[0].value)){
                                            return 0;
                                            }
                                            else {
                                            return y(a[0].value)
                                            }
                                            })
                                      })
                     } else {
                     chartWrapper.append('path')
                     .attr("class", "path")
                     .attr('stroke', colors(d.key))
                     .attr('stroke-width', 2)
                     .attr('fill', 'none')
                     .attr('d', lineGen(d.values))
                     .attr("data-legend", function() {
                           var attr;
                           legendSet.forEach(function(l) {
                                             if (l.key === d.key) {
                                             attr = l.name
                                             }
                                             });
                           return attr;
                           });
                     d.values.forEach(function(a) {
                                      chartWrapper.append("circle")
                                      .attr('fill', colors(d.key))
                                      .attr('stroke', colors(d.key))
                                      .attr("r", 2)
                                      .attr("cx", function() {
                                            return x0(a.key)
                                            })
                                      .attr("cy", function() {
                                            if( a.value == NaN || isNaN(a.value)){ 
                                            return 0;
                                            }
                                            else {
                                            return y(a.value)
                                            }  
                                            })
                                      })
                     }
                     })
        
        //create a lengend element of <g> and append to svg
        legend = svg.append("g")
        .attr("class", "legend")
        .attr('transform', 'translate(5,50)');
        
        //draw legend factors fetching data from the given elements
        legend.selectAll('circle')
        .data(legendSet)
        .enter()
        .append("g")
        .attr("width", "100")
        .attr("height", "50").attr('transform', 'translate(5,0)')
        .attr("class", "legend-item")
        .append("circle")
        .attr("cx", width)
        .attr("cy", function(d, i) {
              return i+15 * i;
              })
        .attr("r", 5)
        .style("fill", function(d, i) { //console.log(d);
               return colors(d.key)
               })
        legend.selectAll('.legend-item')
        .append("text")
        .attr('x', width + 8)
        .attr('y', function(d, i) {
              return i * 15 + 5;
              })
        .text(function(d) {
              return d.name;
              })
    } else {
        svg.append("text")
        .attr("x", width / 2)
        .attr("y", height / 2)
        .attr("text-anchor", "middle")
        .style("font-size", "14px")
        .text("NO DATA");
    }
}