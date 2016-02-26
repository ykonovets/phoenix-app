class PostForm {
  constructor() {
    this.page = $('.post-add-edit-page');
  }

  run() {
    if (this.page == []) {
      return;
    }
    this.setDeleteListeners(this.page)
    self = this;
    this.page.find(".js-add-link-button").on('click', function (e) {
      let data = $(this).data();
      let id = new Date().getTime();
      let newTemplate = $(data.template
        .replace(/_\d+_/g, `_${id}_`)
        .replace(/\[\d+\]/g, `[${id}]`));
      $(data.target).append(newTemplate);
      self.setDeleteListeners(newTemplate);
      e.preventDefault();
    })
  }

  setDeleteListeners(node) {
    node.find(".js-delete-link-button").on("click", function (e) {
      let tr = $(this).parents("tr");
      let id = tr.find(".js-id-field").val();
      if (id == "") {
        tr.remove();
      }
      else {
        tr.find('.js-destroy-field').val(true);
        tr.hide();
      }
      e.preventDefault();
    })
  }
}

class PostShowPage {
  constructor() {
    this.page = $('.post-show-page');
    this.newPostAlert = this.page.find('.js-new-post-alert')
    this.commentsTable = this.page.find('.js-comments-table');
  }

  run() {
    if (this.page == []) {
      return;
    }
    $(document).on("comment:created", this.onCommentCreated.bind(this))
  }

  onCommentCreated(e, comment) {
    let textTd = $("<td>").append(comment.text)
    let authorTd = $("<td>").append(comment.author)
    this.commentsTable.append($("<tr>").append(textTd, authorTd))
    this.newPostAlert.removeClass('hidden')
    setTimeout(function(){ this.newPostAlert.addClass('hidden') }.bind(this), 3000);
  }
}

$(document).ready(function() {
  let postForm = new PostForm();
  let postShowPage = new PostShowPage();

  postForm.run();
  postShowPage.run();
})
