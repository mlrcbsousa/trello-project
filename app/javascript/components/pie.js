const initPie = function () {

var ctx = document.getElementById('myPie').getContext('2d');
var chart = new Chart(ctx, {
    // The type of chart we want to create
    type: 'doughnut',

    // The data for our dataset
    data: {
        labels: ["CS", "AW", "TB", "MS"],
        datasets: [{
            label: "Team performance",
            backgroundColor: ['#EE5F5B', '#00ACC1', '#FFDE33', '#1BE2B0'],
            data: [200, 150, 180, 300],
        }]
    },

    // Configuration options go here
    options: {}
});
};

export { initPie };
