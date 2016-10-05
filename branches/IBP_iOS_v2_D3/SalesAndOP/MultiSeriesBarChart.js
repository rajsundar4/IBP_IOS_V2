function verticleBarChart(chart, presets) {
    var svg, data, x0, x1, y, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
        width, height, XAxisKey, keys, datasets;

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

    //setting the user defined colorPallete
    var colors = d3.scale.ordinal()
        .range(presets.plotArea.colorPalette);

    data = presets.dataset;
    //get the keys of enitre data
    keys = d3.keys(data[0]);

    //fetch the XCordinate dynamically or given in presets
    var XAxisKeyraw = presets.dimensions[0].value;
    XAxisKey = XAxisKeyraw.replace(/[{}]/g, '');

    //fetch the y axis keys apart from x-axis 
    datasets = d3.keys(data[0]).filter(function(key) {
        return key !== XAxisKey;
    });

    //mapping (grouping) the data as required to render 
    data.forEach(function(d) {
        d.values = datasets.map(function(name) {
            return {
                key: d["" + XAxisKey + ""],
                name: name,
                value: +Number(d[name])
            };
        });
    });

    //initialize scales
    xExtent = data.map(function(d) {
        return d["" + XAxisKey + ""];
    });

    //legend data manipulation
    var legendSet = presets.measures;
    //overWrite with un-braced data values
    legendSet = legendSet.map(function(l) {
        return {
            name: l.name,
            key: l.value.replace(/[{}]/g, '')
        }
    })

    //scaling axis
    x0 = d3.scale.ordinal().rangeRoundBands([10, width], 0.3).domain(xExtent); //Actual x-Axis Scale
    x1 = d3.scale.ordinal().domain(datasets).rangeRoundBands([10, x0.rangeBand()], 0.1); //Series Scaling on X-Axis 
    y = d3.scale.linear().domain([0, d3.max(data, function(d) {
        return d3.max(d.values, function(d) {
            return d.value;
        });
    })]).range([height, 20]); //y-Axis Scale

    //initialize axis and formatting
    xAxis = d3.svg.axis().orient('bottom');
    yAxis = d3.svg.axis().orient('left');
    var yFormat = d3.format('.1s');

    //initialize svg
    svg = d3.select("#" + chart).append('svg')
        .attr("width", BBox.width)
        .attr("height", h)
        // .attr("preserveAspectRatio", "xMinYMin slice")
        // .attr("viewBox", "0 0 480 307")
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    chartWrapper = svg.append('g').attr("class", "chartWrapper");
    chartWrapper.append('g').classed('x axis', true)
    chartWrapper.append('g').classed('y axis', true);

    //Axis Ticks
    xAxis.scale(x0).tickSize(2);
    yAxis.scale(y).tickSize(1).tickFormat(yFormat).ticks(6);

    //Append x-Axis to svg
    svg.select('.x.axis')
        .attr('transform', 'translate(0,' + (height) + ')')
        .call(xAxis);

    //Append y-Axis to svg
    svg.select('.y.axis')
        .attr('transform', 'translate(' + (margin.left / 2) + ',' + 0 + ')')
        .call(yAxis);

    //draw y lines inside the chart
    svg.selectAll(".y >.tick > line")
        .attr("x2", width - margin.left);
    
    //create groups for each series
    var set = svg.select("g.chartWrapper").selectAll(".dataset")
        .data(data)
        .enter().append("g")
        .attr("class", "dataset")
        .attr("transform", function(d, i) {
            return "translate(" + (x0(d["" + XAxisKey + ""])) + "," + 0 + ")";
        })
        
        //create rect and render y-values.
    set.selectAll(".rect")
        .data(function(d, i) {
            return d.values
        })
        .enter()
        .append("rect")
        .attr("width", x1.rangeBand())
        .attr("x", function(d) {
            return x1(d.name);
        })
        .attr("y", function(d) {
            var value = y(d.value);
            if (isNaN(value)) {
                return 0;
            } else {
                return value;
            }
        })
        .attr("height", function(d) {
            var value = y(d.value);
            if (isNaN(value)) {
                return 0;
            } else {
                return height - value;
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
        })


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
}