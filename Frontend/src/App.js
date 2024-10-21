import { BrowserRouter as Router, Route, Routes, useNavigate } from 'react-router-dom';
import LandingPage from './pages/LandingPage';
import HomePage from './pages/HomePage';
import CreateRoomPage from './pages/CreateRoomPage';
import JoinRoomPage from './pages/JoinRoomPage';
import VirtualRoomPage from './pages/VirtualRoomPage';
import AddRoommatePage from './pages/AddRoommatePage';
import NotificationsPage from './pages/NotificationsPage';

// Amplify UI components
import { Authenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';

import axios from 'axios'
import UserProfile from './pages/UserProfile';
import ScrollToTop from './ScrollToTop';

function App() {
  // Function to handle adding the user to the mock database
  const handleUserSignIn = async (user) => {
    const email = user?.signInDetails?.loginId; // Extract user email from the Amplify user object

    if (email) {
      try{
        // Send a POST request to add the user to the database
        const response = await axios.post('https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/user/add-user',
           {id: email,});

           console.log('User added successfully:', response.data);
      } catch (error) {
          console.error('Error while adding user:', error);
        }
      }
    };

  // Component to handle login and redirection to /home
  const LoginRedirect = () => {
    const navigate = useNavigate();

    return (
      <div className="centered-auth">
        <Authenticator>
          {({ signOut, user }) => {
            console.log("User object from Authenticator:", user);
            handleUserSignIn(user);
            
            // Redirect to /home after login
            if (user) {
              navigate('/home');
            }

            return null; // Return null since the redirect will handle the navigation
          }}
        </Authenticator>
      </div>
    );
  };

  return (
    <Router>
      <ScrollToTop/>
      <div className="App">
        <Routes>
          {/* Public Route - Landing Page */}
          <Route path="/" element={<LandingPage />} />

          {/* Login Route */}
          <Route path="/login" element={<LoginRedirect />} />

          {/* Protected Routes */}
          <Route
            path="/home"
            element={
              <Authenticator>
                {({ signOut, user }) => {
                  handleUserSignIn(user); 
                  return <HomePage user={user} signOut ={signOut} />;
                }}
              </Authenticator>
            }
          />
             <Route
            path="/user-profile"
            element={
              <Authenticator>
                {({ signOut, user }) => {
                  handleUserSignIn(user);
                  return <UserProfile user={user} signOut={signOut} />;
                }}
              </Authenticator>
            }
          />
          <Route
            path="/create-room"
            element={
              <Authenticator>
                {({ signOut, user }) => {
                  handleUserSignIn(user);
                  return <CreateRoomPage user={user} />;
                }}
              </Authenticator>
            }
          />
          <Route
            path="/join-room"
            element={
              <Authenticator>
                {({ signOut, user }) => {
                  handleUserSignIn(user);
                  return <JoinRoomPage user={user} />;
                }}
              </Authenticator>
            }
          />
          <Route
            path="/virtual-room"
            element={
              <Authenticator>
                {({ signOut, user }) => {
                  handleUserSignIn(user);
                  return <VirtualRoomPage user={user} />;
                }}
              </Authenticator>
            }
          />
          <Route
            path="/add-roommate-page"
            element={
              <Authenticator>
                {({ signOut, user }) => {
                  handleUserSignIn(user);
                  return <AddRoommatePage user={user} />;
                }}
              </Authenticator>
            }
          />
          <Route
            path="/notifications"
            element={
              <Authenticator>
                {({ signOut, user }) => {
                  handleUserSignIn(user);
                  return <NotificationsPage user={user} />;
                }}
              </Authenticator>
            }
          />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
