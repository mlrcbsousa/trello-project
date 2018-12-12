import "bootstrap";
import { initChart } from '../components/chart';
require Chart.bundle
require chartkick

const showChart = document.getElementById("chart-1");
  if (showChart) {
    initChart();
};
