

const initChart = function () {
  var ctx = document.getElementById('myChart').getContext('2d');
  var chart = new Chart(ctx, {
      // The type of chart we want to create
      type: 'line',

      // The data for our dataset
      data: {
          labels: ["1", "2", "3", "4", "5", "6", "7"],
          datasets: [{
              label: "Story points remaining",
              backgroundColor: '#026AA7',
              borderColor: 'rgb(255, 255, 255)',
              data: [600, 540, 520, 400, 300, 250, 5],
          }]
      },

      // Configuration options go here
      options: {}
  });
};

export { initChart };
