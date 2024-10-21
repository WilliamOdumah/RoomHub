import React, {useState} from 'react'
import { useNavigate } from 'react-router-dom';
import { getUserById } from '../mockApi';


const LoginPage = () =>{
    const navigate = useNavigate();
    // const [hasRoom, setHasRoom] = useState(false);
    const [email, setEmail] = useState('');
    const [error, setError] = useState('');

    // Function to handle input change
    const handleEmailChange = (event) => {
      setEmail(event.target.value);  // Update state with the entered email
    };
    
    const handleLogin = () => {
        // Do some backend logic and database stuff

        const user =  getUserById(email);  // Check if the user exists in the mock database
        
        if (!user) {
            // If the user doesn't exist, display an error message
            setError('User does not exist. Please sign up.');
            return;
        }

        // Check if the user has a roomId
        const hasRoom = !!user.roomId;  // Boolean flag for room existence

        // Navigate to the home page, passing the email and hasRoom status
        navigate('/home', { state: { hasRoom, email } });
    }

    return (
        <div>
          <h1>Login Page</h1>
          {/* Choose to log in as a user with an existing room or no room */}
          {/* This simulates our eventual database knowing what users have rooms for the conditionally rendered Homepage */}
          
          {/* <select onChange={(e) => setHasRoom(e.target.value === 'yes')}>
            <option value="no">No Room</option>
            <option value="yes">Have Room</option>
          </select> */}
          {/* Input field for email */}
          <label htmlFor="email">Email:</label>
          <input
              type="email"
              id="email"
              name="email"
              value={email}
              onChange={handleEmailChange}
              required
          />
          <button onClick={handleLogin}>Log In</button>

          {/* Error message display */}
          {error && <p style={{ color: 'red' }}>{error}</p>}
          <p>
            Don't have an account? <a href="/signup">Sign Up</a>
          </p>
        </div>
    );
}

export default LoginPage;