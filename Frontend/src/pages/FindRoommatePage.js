import React, { useState, useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import styles from '../styles/FindRoommatePage.module.css';
import Header from '../Header';
import axios from 'axios';

const FindRoommatePage = () => {
  const [profiles, setProfiles] = useState([]);
  const [matchedUser, setMatchedUser] =useState(null);
  const [index, setIndex] = useState(0);
  const [noMoreUsers, setNoMoreUsers] = useState(false);
  const [matchMessage, setMatchMessage] = useState(null);
  const [isPageBlurred, setIsPageBlurred] = useState(false);
  const location = useLocation();
  const navigate = useNavigate();
  const hasRoom = location.state?.hasRoom;
  const email = location.state?.email;

  useEffect(() => {
    const fetchProfiles = async () => {
      try {
        const response = await axios.get(
          `https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/user/${email}/get-new-matches`
        );
        if (response.status === 200) {
          const fetchedProfiles = response.data.profiles;

          // Shuffle profiles to display them in a random order
          const shuffledProfiles = fetchedProfiles.sort(() => Math.random() - 0.5);
          console.log(shuffledProfiles);
          console.log("Those are the shuffled profiles");
          setProfiles(shuffledProfiles);
        }
      } catch (error) {
        console.error('Error fetching profiles:', error);
        alert('Failed to fetch profiles. Please try again later.');
      }
    };

    fetchProfiles();
  }, [email]);

  const handleLike = async () => {
    const likedUserId = profiles[index]?.user_id;
  
    try {
      const response = await axios.post(
        `https://7hm4udd9s2.execute-api.ca-central-1.amazonaws.com/dev/profile/${email}/check-match`,
        { id: likedUserId }
      );
  
      if (response.status === 200) {
        if (response.data.message === "users are a match. Added to each matches list") {
          setMatchedUser(likedUserId);
          // Show match message
          setMatchMessage(`You matched with ${profiles[index].name}!`);
        } else {
          alert(`You liked ${profiles[index].name}!`);
        }
      }
    } catch (error) {
      console.error('Error checking match:', error);
      alert('An error occurred while processing your like. Please try again.');
    }
  
     // Navigate to the next profile after a delay (if not a match)
     if (!matchMessage) {
      if (index < profiles.length - 1) {
        setIndex((prevIndex) => prevIndex + 1);
      } else {
        setNoMoreUsers(true);
      }
    }
  };
  
  const handleViewProfile = () => {
    // Navigate to the matched user's profile
    navigate('/user-profile', { state: { email, matchedUser, hasRoom } });
  };

  
  const handleCloseModal = () => {
    setIsPageBlurred(false);
    setMatchMessage(null);
    if (index < profiles.length - 1) {
      setIndex((prevIndex) => prevIndex + 1);
    } else {
      setNoMoreUsers(true);
    }
  };

  const handleDislike = () => {
    if (index < profiles.length - 1) {
      setIndex((prevIndex) => prevIndex + 1);
    } else {
      setNoMoreUsers(true);
    }
  };

  const currentUser = profiles[index];

  return (
    <div className={`${styles.container} ${isPageBlurred ? styles.blurred : ''}`}>
      <Header email={email} hasRoom={hasRoom} />
      {matchMessage && (
        <div className={styles.modal}>
          <div className={styles.modalContent}>
            <h2>{matchMessage}</h2>
            <button onClick={handleViewProfile} className={styles.viewProfileButton}>
              View Profile
            </button>
            <button onClick={handleCloseModal} className={styles.closeButton}>
              Close
            </button>
          </div>
        </div>
      )}
      {noMoreUsers || profiles.length === 0 ? (
        <div className={styles.endMessage}>
          <p>No more roommates available based on your current location.</p>
          <button onClick={() => window.location.reload()}>Reload Page</button>
          <button onClick={() =>navigate('/user-profile', { state: { email, hasRoom } })}>Change Location In User Profile</button>
        </div>
      ) : (
        <div className={styles.card}>
          <h2>{currentUser.name.toUpperCase()}</h2>
          <h2>{new Date().getFullYear() - new Date(currentUser.dob).getFullYear()}</h2>
          <p>{currentUser.bio}</p>
          <div className={styles.tags}>
            {currentUser.tags.map((tag, idx) => (
              <span key={idx} className={styles.tag}>{tag}</span>
            ))}
          </div>
          <div className={styles.rating}>
            Roommate Rating: {currentUser.overall || "N/A"}
            <div className={styles.ratingTooltip}>
              <p>Cleanliness: {currentUser.cleanliness || "N/A"}</p>
              <p>Noise Levels: {currentUser.noise_levels || "N/A"}</p>
              <p>Chores: {currentUser.chores || "N/A"}</p>
              <p>Communication: {currentUser.communication || "N/A"}</p>
              <p>Paying Rent: {currentUser.paying_rent || "N/A"}</p>
              <p>Respect: {currentUser.respect || "N/A"}</p>
            </div>
          </div>
          <div className={styles.buttons}>
            <button className={styles.actionButton} onClick={handleDislike}>❌ Dislike</button>
            <button className={styles.actionButton} onClick={handleLike}>✅ Like</button>
          </div>
        </div>
      )}
    </div>
  );
};

export default FindRoommatePage;
