function deleteItem(id) {
  $.post("/home/list.delete?item_id="+id, function(){
    //on success of post, remove table row with same id to keep consistent with sql data
    alert('stuff happened');
    $("#"+id).remove();
    //if list is empty, change title text
    if ($("#list_table").has("tr").length == 0) {
      $("#list_title").text("Your List is Empty");
    }
  });
}

function deleteList(id) {
  // $.delete("/items/10")
  $.post("/home.delete?list_id="+id, function(){
    //on success of post, remove table row with same id to keep consistent with sql data
    alert('stuff happened');
    $("#"+id).remove();
    //if list is empty, change title text
    if ($("#list_table").has("tr").length == 0) {
      //$("#list_title").text("You have no lists.");
      $("#list_table").html("<tr><td>You have no lists</td></tr>");
    }
  });
}
