import "bootstrap";
import { initChart } from '../components/chart';
import { initPie } from '../components/pie';
import { initBar } from '../components/bar';

const showChart = document.getElementById("myChart");
  if (showChart) {
    initChart();
};

const showPie = document.getElementById("myPie");
  if (showPie) {
    initPie();
};

const showBar = document.getElementById("myBar");
  if (showBar) {
    initBar();
};
