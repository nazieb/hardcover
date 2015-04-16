$(document).ready(function() {
    $("#select").on("change", function() {
      var url = $(this).val();

      if (url) {
        window.location = url;
      }

      return false;
    });
});
