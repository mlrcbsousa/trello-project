import "bootstrap";
import { initChart } from '../components/chart';
import { initPie } from '../components/pie';
import { initBar } from '../components/bar';

import 'flatpickr/dist/flatpickr.css';
import { SprintDatepickers } from '../components/datepicker';

import Chartkick from "chartkick";
window.Chartkick = Chartkick;

const initPicker = document.getElementById("dates");
  if (initPicker) {
    SprintDatepickers();
};

// for Chart.js
import Chart from "chart.js";
Chartkick.addAdapter(Chart);

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
