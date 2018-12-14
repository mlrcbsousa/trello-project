import flatpickr from "flatpickr";

const SprintDatepickers = function () {
  const startDateinput = document.getElementById('sprint_start_date');
  const endDateinput = document.getElementById('sprint_end_date');

  flatpickr(startDateinput, {
    dateFormat: 'd-m-Y'
  });

  flatpickr(endDateinput, {
    dateFormat: 'd-m-Y'
  });
};

export { SprintDatepickers };
