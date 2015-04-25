$(function() {
    $(".delete-question").click(function(e) {
        e.preventDefault();
        var id = $(this).data("question-id");
        $.ajax({
            url: "/question/" + id,
            method: "DELETE",
            complete: function(xhr, status) {
                if (xhr.status == 200) {
                    document.location.href = "/?message=question.delete.confirmation";
                } else if (xhr.status == 400) {
                    alert(xhr.responseText);
                } else {
                    alert("An unknown error occurred");
                }
            }
        })
    })
});