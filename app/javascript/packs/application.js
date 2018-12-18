import "bootstrap";
import { initChart } from '../components/chart';
import { initPie } from '../components/pie';
import { initBar } from '../components/bar';

import 'flatpickr/dist/flatpickr.css';
import { SprintDatepickers } from '../components/datepicker';

import { initTabs } from "../components/tabs";

// for Chart.js
import Chart from "chart.js";
Chartkick.addAdapter(Chart);

import Chartkick from "chartkick";
window.Chartkick = Chartkick;

const sidebarTabs = document.getElementById('sidebar-tabs_js');
if (sidebarTabs) {
  initTabs();
}

const initPicker = document.getElementById("dates");
  if (initPicker) {
    SprintDatepickers();
};

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
