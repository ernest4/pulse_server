import React from "react";
import { BrowserRouter, Switch, Route, Link } from "react-router-dom";
import Game from "./Game";
import UI from "./UI";

const App = () => (
  <BrowserRouter>
    <NavBar />
    <Body />
  </BrowserRouter>
);

export default App;

const NavBar = () => (
  <nav>
    <div>
      <Link to="/app/">Home</Link>
    </div>
    <div>
      <Link className="bg-blue-500" to="/app/players">Players</Link>
    </div>
    <div>
      <Link to="/app/groups">Groups</Link>
    </div>
    <div>
      <Link to="/app/play">Play</Link>
    </div>
    <div>
      <Link to="/app/account">Account</Link>
    </div>
  </nav>
);

const Body = () => (
  <Switch>
    <Route path="/app/" exact component={() => <div>Home</div>} />
    <Route path="/app/players" component={() => <div>Players</div>} />
    <Route path="/app/groups" component={() => <div>Groups</div>} />
    {/* These will be AuthRoutes */}
    <Route
      path="/app/play"
      component={() => (
        <div>
          <UI />
          <Game />
        </div>
      )}
    />
    <Route path="/app/account" component={() => <div>Account</div>} />
  </Switch>
);

// TODO: add <AuthRoute /> that checks if user is logged in to access certain content !!!

// class ProtectedRoute extends React.Component {
//   render() {
//       const Component = this.props.component;
//       const isAuthenticated = ???; ajax request to back end to check log instate (uid in session) then respond (and cache the answer??)
//       return isAuthenticated ? (
//           <Component />
//       ) : (
//           <Redirect to={{ pathname: '/login' }} />
//       );
//   }
// }

// TODO: deprecate server side views entirely in favour of react front end (clean separation)
