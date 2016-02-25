class PostForm {
  constructor() {
    this.page = $('.js-post-form');
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

class CommentForm {
  constructor() {
    this.page = $('.js-post-form');
    this.commentsTable = $('.js-comments-table');
  }

  run() {
    if (this.page == []) {
      return;
    }
    this.setDeleteListeners(this.page)
    $(document).on("comment:created", this.onCommentCreated.bind(this))

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

  onCommentCreated(e, comment) {
    let textTd = $("<td>").append(comment.text)
    let authorTd = $("<td>").append(comment.author)
    this.commentsTable.append($("<tr>").append(textTd, authorTd))
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

$(document).ready(function() {
  let postForm = new PostForm();
  let commentForm = new CommentForm();

  postForm.run();
  commentForm.run();
})
