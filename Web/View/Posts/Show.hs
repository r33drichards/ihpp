module Web.View.Posts.Show where
import Web.View.Prelude

import qualified Text.MMark as MMark


data ShowView = ShowView { post :: Include "comments" Post }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{post.title}</h1>
        <p>{post.createdAt |> timeAgo}</p>
        <p>{post.body |> renderMarkdown}</p>

        <a href={NewCommentAction post.id}>Add Comment</a>

        <h2>Comments</h2>
        {forEach post.comments renderComment}


    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ]


renderComment :: Comment -> Html
renderComment comment = [hsx|
    <div class="card">
        <div class="card-body">
            <h5 class="card-title">{comment.author}</h5>
            <p class="card-text">{comment.body |> renderMarkdown}</p>
        </div>
    </div>|]

renderMarkdown text =
    case text |> MMark.parse "" of 
        Left err -> "Something went wrong"
        Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml