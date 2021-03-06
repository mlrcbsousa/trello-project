const initBar = function () {

var ctx = document.getElementById('myBar').getContext('2d');
var stackedBar = new Chart(ctx, {
    type: 'horizontalBar',

    // The data for our dataset
    data: {
        labels: ["CS", "AW", "TB", "MS"],
        datasets: [{
            label: "Team performance",
            backgroundColor: ['#EE5F5B', '#00ACC1', '#FFDE33', '#1BE2B0'],
            data: [200, 150, 180, 250],
        }]
    },

    // Configuration options go here
    options: {}
});
};

export { initBar };
