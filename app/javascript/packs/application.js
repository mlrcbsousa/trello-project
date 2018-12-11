import "bootstrap";
import { initChart } from '../components/chart';
require Chart.bundle
require chartkick

const showChart = document.getElementById("burndown");
  if (showChart) {
    initChart();
};
