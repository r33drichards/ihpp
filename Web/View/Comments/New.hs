module Web.View.Comments.New where
import Web.View.Prelude
import Language.LSP.Types.Lens (HasTitle(title))
import Web.View.Prelude (hiddenField)


data NewView = NewView 
    { comment :: Comment
    , post :: Post
    }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Comment <q>{post.title}</q></h1>
        {renderForm comment}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Comments" CommentsAction
                , breadcrumbText "New Comment"
                ]

renderForm :: Comment -> Html
renderForm comment = formFor comment [hsx|
    {(hiddenField #postId)}
    {(textField #author)}
    {(textField #body)}
    {submitButton}

|]