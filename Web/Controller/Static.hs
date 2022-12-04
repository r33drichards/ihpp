module Web.Controller.Static where
import Web.Controller.Prelude
import Web.View.Static.Welcome
import Web.View.Static.GithubCommits
import IHP.RouterSupport


import qualified GitHub as Github
import Data.Vector ( toList )


getAllCommits = Github.commitsForR "r33drichards" "brev-cli" Github.FetchAll

getCommits =  Github.executeRequest' getAllCommits






instance Controller StaticController where
    action GithubCommitsAction = do
        commits <-  getCommits
        case commits of
            Right commits -> do
                render GithubCommitsView { commits = Data.Vector.toList commits}
            Left err -> do
                render GithubCommitsView { commits = []}
            

    action WelcomeAction = do 
        render WelcomeView{ 
            githubActionPath = pathTo GithubCommitsAction
         }

        
            