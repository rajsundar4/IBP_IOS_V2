function heatmap(chart, presets) {
    var svg, data, x, y, z, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
    width, height, XAxisKey, SeriesKey, keys, datasets = [],
    yVArray = [],
    yKArray = [],
    xKArray = [];
    
    //get the DOM Factors(width & Height) where this chart will be rendered
    w = Number(presets.width)
    
    h = Number(presets.height)
    //configs of the svg to be rendered
    margin = {
    top: 15,
    right: 0.10 * w,
    bottom: 0.10 * w,
    left: 0.20 * w
    }
    width = w - margin.left - margin.right;
    height = h - margin.top - margin.bottom;
    
    //setting the user defined colorPallete
    var z = d3.scale.ordinal()
    .range(["#FFD900", "#D10000"]);
    
    data = presets.dataset;
    
    //get the keys of enitre data
    keys = d3.keys(data[0]);
    
    //fetch the XCordinate dynamically or given in presets
    for (var i = 0; i <= presets.dimensions.length - 1; i++) {
        if (presets.dimensions[i].axis === 1) {
            XAxisKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }
        if (presets.dimensions[i].axis === 2) {
            SeriesKey = presets.dimensions[i].value.replace(/[{}]/g, '');
        }
    }
    
    //legend data manipulation
    yMeasure = presets.measures;
    //overWrite with un-braced data values
    yMeasure = yMeasure.map(function(l) {
                            return {
                            name: l.name,
                            key: l.value.replace(/[{}]/g, '')
                            }
                            })
    
    if (SeriesKey) { // if a series key i.e, axis : 2 is specified in data then
        keys.map(function(key) {
                 if (key !== XAxisKey && key !== SeriesKey) {
                 datasets.push(key);
                 } else {
                 return;
                 }
                 });
        
        //function to check for duplicates
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
        
        //datasets will have y-key name that will be used to plot
        data.forEach(function(d) {
                     datasets.forEach(function(name) {
                                      yKArray.push(d[SeriesKey]); //push out the series values as one array
                                      yVArray.push(Number(d[name])); //create an array of all values to use on y-axis scale to range specification
                                      xKArray.push(d[XAxisKey]);
                                      });
                     });
        
        sKeys = yKArray.unique(); //avoid duplicates
        xKeys = xKArray.unique(); //avoid duplicates
        ygridSize = Math.floor(height / sKeys.length);
        xgridSize = Math.floor(width / xKeys.length);
        var yValues = [];
        data.map(function(d) {
                 d.xkey = d[XAxisKey],
                 d.ykey = d[SeriesKey],
                 d.value = d[datasets[0]]
                 yValues.push(d[datasets[0]])
                 delete d[XAxisKey];
                 delete d[SeriesKey];
                 delete d[datasets[0]];
                 });
        
        //initialize scales
        xExtent = data.map(function(d) {
                           return d.xkey;
                           });
        
        x = d3.scale.ordinal().rangeRoundBands([0, width]).domain(xKeys); //Actual x-Axis Scale
        y = d3.scale.ordinal().rangeRoundBands([height, 0]).domain(sKeys) //.nice();
        min = d3.min(yValues, function(d) {
                     return d;
                     })
        max = d3.max(yValues, function(d) {
                     return d;
                     })
        z.domain([min, max]);
        //initialize svg
        svg = d3.select("#" + chart).append('svg')
        .attr("width", w)
        .attr("height", h)
        .append("g")
        .attr("transform", "translate(" + (margin.left - 20) + "," + (margin.top) + ")")
        
        chartWrapper = svg.append('g').attr("class", "chartWrapper");
        var dataset = chartWrapper.append("g").attr("class", "dataset")
        chartWrapper.append('g').classed('x axis', true)
        chartWrapper.append('g').classed('y axis', true);
        
        ///Axis Ticks
        xAxis = d3.svg.axis();
        var evenOnes = [];
        
        function splitArray(candid) {
            for (var i = 0; i < candid.length; i++)
                if (i % 2 == 0) {
                    evenOnes.push(candid[i]);
                }
        }
        splitArray(xKeys);
        if (xKeys.length > 6) {
            xAxis.tickValues(evenOnes);
        }
        
        xAxis.scale(x).tickSize(3);
        
        var xaxis = svg.select('.x.axis')
        .attr('transform', 'translate(0,' + (height) + ')')
        .call(xAxis.orient('bottom'))
        
        if (xKeys.length > 4) {
            xaxis.selectAll("text")
            .attr("y", 0)
            .attr("x", 9)
            .attr("transform", "rotate(-40)")
            .attr("dx", "-1.2em")
            .attr("dy", ".35em")
            .style("text-anchor", "end");
        }
        var yevenOnes = [];
        
        function ysplitArray(candid) {
            for (var i = 0; i < candid.length; i++)
                if (i % 3 == 0) {
                    yevenOnes.push(candid[i]);
                }
        }
        yAxis = d3.svg.axis().scale(y).orient("left").tickSize(1);
        ysplitArray(sKeys);
        if (sKeys.length > 6) {
            yAxis.tickValues(yevenOnes);
        }
        
        svg.select('.y.axis').call(yAxis);
        
        var cards = dataset.selectAll(".heat-tile")
        .data(data)
        .enter()
        .append("rect")
        .attr("x", function(d, i) {
              return x(d.xkey);
              })
        .attr("y", function(d, i) {
              return y(d.ykey)
              })
        .attr("class", "heat-tile")
        .attr("stroke", "#ffffff")
        .attr("width", xgridSize)
        .attr("height", ygridSize)
        .style("fill", function(d) {
               return z(d.value);
               })
        .text(function(d) {
              return d.ykey
              })
        .style("opacity", "1");
        
        
        //create legend
        if (z.domain()[1]) {
            var legend = svg.selectAll(".legend")
            .data(z.ticks(3).reverse())
            .enter().append("g")
            .attr("class", "legend")
            .attr("x", width + 20)
            .attr("transform", function(d, i) {
                  return "translate(" + (width + 05) + "," + (20 * i) + ")";
                  });
            
            legend.append("rect")
            .attr("width", 20)
            .attr("height", 20)
            .style("fill", z);
            
            legend.append("text")
            .attr("x", 26)
            .attr("y", 20 / 2)
            .attr("dy", ".35em")
            .text(function(d) {
                  return d3.format(".2s")(d);
                  });
        } else {
            var legend = svg
            .append("g")
            .attr("class", "legend")
            .attr("transform", function(d, i) {
                  return "translate(" + (width + 20) + "," + (40 + i * 40) + ")";
                  });
            
            legend.append("rect")
            .attr("width", 20)
            .attr("height", 40)
            .style("fill", z(0));
            
            legend.append("text")
            .attr("x", 26)
            .attr("y", 40 / 2)
            .attr("dy", ".35em")
            .text("0");
        }
        
    } else {
        //seperate Y-Axis Keys from others
        datasets = d3.keys(data[0]).filter(function(d) {
                                           return d !== XAxisKey;
                                           })
        var yValues = [];
        // Coerce the JSON data to the appropriate types.
        data.forEach(function(d) {
                     datasets.forEach(function(name) {
                                      yValues.push(Number(d[name]));
                                      d.key = d[XAxisKey];
                                      d.value = +Number(d[name]);
                                      delete d[XAxisKey];
                                      delete d[name];
                                      })
                     });
        
        avg = d3.sum(data, function(d) {
                     return d.value;
                     }) / data.length;
        
        //initialize scales
        xExtent = data.map(function(d) {
                           return d["key"];
                           });
        
        
        x = d3.scale.ordinal().rangeRoundBands([0, width]).domain(xExtent); //Actual x-Axis Scale
        y = d3.scale.linear().range([height, 0]).domain(d3.extent(yValues, function(d) {
                                                                  return d;
                                                                  }));
        min = d3.min(yValues, function(d) {
                     return d;
                     })
        max = d3.max(yValues, function(d) {
                     return d;
                     })
        z.domain([min, max]);
        
        //initialize svg
        svg = d3.select("#" + chart).append('svg')
        .attr("width", w)
        .attr("height", h)
        .append("g")
        .attr("transform", "translate(" + 20 + "," + 20 + ")");
        
        chartWrapper = svg.append('g').attr("class", "chartWrapper");
        
        var set = chartWrapper.selectAll(".tile")
        .data(data)
        .enter().append("g")
        .attr("class", "tile")
        chartWrapper.selectAll(".tile")
        .append("rect")
        .attr("class", "heat-tile")
        .attr("stroke", "#ffffff")
        .style("fill", function(d) {
               return z(d.value);
               })
        .attr("x", function(d) {
              return x(d.key);
              })
        .attr("y", 0)
        .attr("width", x.rangeBand())
        .attr("height", y(0))
        
        
        chartWrapper.selectAll(".tile")
        .append("text")
        .attr("class", "text")
        .style("text-anchor", "middle")
        .attr("x", function(d) {
              return x(d.key) + x.rangeBand() / 2;
              })
        .attr("y", height / 2)
        .text(function(d) {
              return d["key"];
              });
        legend = [];
        z.ticks().forEach(function(d) {
                          if (d === parseInt(d, 10)) {
                          legend.push(d);
                          } else {
                          return;
                          }
                          })
        //create legend
        if (z.domain()[1]) {
            var legend = svg.selectAll(".legend")
            .data(legend.reverse())
            .enter().append("g")
            .attr("class", "legend")
            .attr("x", width + 20)
            .attr("transform", function(d, i) {
                  return "translate(" + (width + 05) + "," + (20 * i) + ")";
                  });
            
            legend.append("rect")
            .attr("width", 20)
            .attr("height", 20)
            .style("fill", z);
            
            legend.append("text")
            .attr("x", 26)
            .attr("y", 20 / 2)
            .attr("dy", ".35em")
            .text(function(d) {
                  return d3.format(".2s")(d);
                  });
        } else {
            var legend = svg
            .append("g")
            .attr("class", "legend")
            .attr("transform", function(d, i) {
                  return "translate(" + (width + 20) + "," + (40 + i * 40) + ")";
                  });
            
            legend.append("rect")
            .attr("width", 20)
            .attr("height", 40)
            .style("fill", z(0));
            
            legend.append("text")
            .attr("x", 26)
            .attr("y", 40 / 2)
            .attr("dy", ".35em")
            .text("0");
        }
    }
}