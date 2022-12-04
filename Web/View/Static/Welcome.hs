
module Web.View.Static.Welcome where
import Web.View.Prelude
import Network.HTTP.Link (href)
import Web.Controller.Prelude (StaticController(GithubCommitsAction))

data WelcomeView = WelcomeView
    { githubActionPath :: Text
    }

instance View WelcomeView where 
    html WelcomeView { .. } = [hsx|
        <h1>Welcome to IHP</h1>
        <p>Here are some links to get you started:</p>
        <ul>

            <li><a href={githubActionPath}>View Commits</a></li>
        </ul>
    |]



