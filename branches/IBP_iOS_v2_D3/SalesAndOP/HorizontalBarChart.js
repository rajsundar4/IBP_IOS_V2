function hChart(chart, presets) {
    var svg, data, x, y0, y1, xAxis, yAxis, dim, chartWrapper, line, path, margin = {},
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
    yExtent = data.map(function(d) {
        return d["" + XAxisKey + ""];
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

    //Initialise AXES
    x = d3.scale.linear().domain([0, Math.ceil(d3.max(arr) / 1000) * 1000]).range([margin.left / 2, width]);
    y0 = d3.scale.ordinal().rangeRoundBands([height, 0], .3).domain(yExtent);
    y1 = d3.scale.ordinal().domain(datasets).rangeRoundBands([0, y0.rangeBand()], .1);

    //scaling and plotting of axes 
    xAxis = d3.svg.axis().scale(x).orient("bottom").tickFormat(d3.format(".2s"));
    yAxis = d3.svg.axis().scale(y0).orient("left").tickSize(1);

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

    //Append x-Axis to svg
    svg.select('.x.axis')
        .attr('transform', 'translate(0 , ' + (height) + ')')
        .call(xAxis);

    //Append y-Axis to svg
    svg.select('.y.axis')
        .attr('transform', 'translate(' + (margin.left / 2) + ',' + 0 + ')')
        .call(yAxis);

    //draw y lines inside the chart
    svg.selectAll(".x >.tick > line")
        .attr("y2", -height);

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
            return d.values
        })
        .enter()
        .append("rect")
        .attr("height", y1.rangeBand())
        .attr("x", margin.left / 2)
        .attr("y", function(d) {
            return y1(d.name);
        })
        .attr("width", function(d) {
            return x(d.value);
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