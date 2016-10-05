function GeoBubble(chart, rawdata) {
    var svg , projection, path, zoom, size = [], force, node, r, min, max, avg, legendSet = [];

    //get the DOM Factors(width & Height) where this chart will be rendered
    var BBox = d3.select("#" + chart).node().getBoundingClientRect();

    var h = .45 * BBox.width; //Calculated height for window based on width fetched from "BBox"

    //configs of the svg to be rendered
    margin = {
        top: 40,
        right: 0.18 * BBox.width,
        bottom: 40,
        left: 0.10 * BBox.width
    }
    width = BBox.width - margin.left - margin.right;
    height = h - margin.top - margin.bottom;
    
    //get the keys of enitre data
    keys = d3.keys(data[0]);

    //initialize svg
    svg = d3.select("#" + chart).append('svg')
        .attr("width", BBox.width)
        .attr("height", h)
       
       var g = svg.append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");  

    projection = d3.geo.mercator();

    path = d3.geo.path()
            .projection(projection); 

    $.ajax({
        type: "GET",
        url: "https://gist.githubusercontent.com/abenrob/787723ca91772591b47e/raw/8a7f176072d508218e120773943b595c998991be/world-50m.json",
        dataType: "json",
        async: false,
        success: function(world) {
             g.selectAll("path")
                .data([topojson.object(world, world.objects.land)])
                .enter().append("path").attr("class", "land")
                .attr("d", path);

            g.selectAll("boundary")
                .data([topojson.object(world, world.objects.countries)])
                .enter().append("path").attr("class", "boundary")
                .attr("d", path);
        }
    });    

   data.forEach(function(d){
        size.push(d.PROJDOC1);
   })
              
    node = g.selectAll(".bubble")
            .data(data)
            .enter().append("g")
            .attr("class","bubble")
            .attr("id", function(d) {
                return d.LOCID;
            })

    r = d3.scale.sqrt()
            .domain([0, d3.max(size)])
            .range([0, 15]);

    node.append("circle")  
        .attr("transform", function(d) {
            var cordinates = [d.GEOLONGITUDE, d.GEOLATITUDE]
            return "translate(" + projection(cordinates) + ")";
        })
        .attr("class", "node")
        .attr('fill', '#748CB2')
        .attr('opacity', 1)
        .attr('fill-opacity', 0.8)
        .attr('r', function(d, i) {
            return r(d.PROJDOC1) + 5;
        })

    var zoom = d3.behavior.zoom()
        .on("zoom",function() {
            g.attr("transform","translate("+ 
                d3.event.translate.join(",")+")scale("+d3.event.scale+")");
            g.selectAll("circle")
                .attr("d", path.projection(projection));
            g.selectAll("path")  
                .attr("d", path.projection(projection)); 

      });

    svg.call(zoom)

    min = d3.min(size);
    max = d3.max(size);
    avg = Math.round(d3.sum(size)/size.length);

   

    var legend = svg.append("g")
    .attr("class", "legend")
   .attr('transform', 'translate('+ (BBox.width-margin.right) +','+ (height-margin.bottom )+')')
  .selectAll("g")
    .data([min, avg, max])
  .enter().append("g");

legend.append("circle")
    .attr("cy", function(d) { return -r(d)+2; })
    .attr("r", r);

legend.append("text")
    .attr("y", function(d) { return -2 * r(d); })
    .attr("dy", "1.3em")
    .text(d3.format(".1s"));

}

