const checks = () => {
  $('#all').on('click', function() {
    $("input[name='fixed_trip[detail_ids][]']").prop('checked', this.checked);
  });
};
window.addEventListener("load", checks);