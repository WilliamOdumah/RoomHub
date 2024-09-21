import React, {useState} from 'react'
import { useNavigate } from 'react-router-dom';


const LoginPage = () =>{
    const navigate = useNavigate();
    const [hasRoom, setHasRoom] = useState(false)
    
    const handleLogin = () => {
        // Do some backend logic and database stuff
        navigate('/home', { state: { hasRoom } })
    }

    return (
        <div>
          <h1>Login Page</h1>
          {/* Choose to log in as a user with an existing room or no room */}
          {/* This simulates our eventual database knowing what users have rooms for the conditionally rendered Homepage */}
          <select onChange={(e) => setHasRoom(e.target.value === 'yes')}>
            <option value="no">No Room</option>
            <option value="yes">Have Room</option>
          </select>
          <button onClick={handleLogin}>Log In</button>
          <p>
            Don't have an account? <a href="/signup">Sign Up</a>
          </p>
        </div>
    );
}

export default LoginPage;