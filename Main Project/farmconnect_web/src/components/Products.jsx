import React, { useState, useEffect } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import { Link } from 'react-router-dom';  
import firestore from '../firebase';
import Sidebar from './SideBar';


function Products() {

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      window.location.href = '/'; 
    }
  }, []);

  const handleLogout = () => {
    localStorage.removeItem('token');
    window.location.href = '/';
  };

  return (
    <div><div className="container-scroller">
      <Sidebar/>
      <div className="container-fluid page-body-wrapper mb-0">
      <nav className="navbar p-0 fixed-top d-flex flex-row" style={{ backgroundColor: '#000' }}>
    {/* <div className="w-100 d-flex justify-content-center align-items-center">
      <h3 className="text-center mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
        FarmConnect Admin Dashboard
      </h3>
    </div> */}
</nav>

      <div>
        <div className="text-center" style={{ marginLeft: '1340px' }}>
            <button className="btn btn-danger" onClick={handleLogout}>Logout</button>
         </div>

         <div className="w-100 d-flex justify-content-center align-items-center">
            <h3 className="text-center mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
              Products
            </h3>
          </div>
         
        <div className="content-wrapper">
        <div className="row" style={{ marginLeft: "180px" }}>
            
            
            <div className="col-sm-4 grid-margin">
            <Link to="/all-products" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div>
                    <div>
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-4 mt-4">All Products</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/stock-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div>
                    <div>
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-4 mt-4">Stock</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/products-pending" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div>
                    <div>
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-4 mt-4">Products Pending</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/products-approved" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div>
                    <div>
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-4 mt-4">Products Approved</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/products-rejected" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div>
                    <div>
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-4 mt-4">Products Rejected</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            
            <div className="col-sm-4 grid-margin">
            <Link to="/review-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div>
                    <div>
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-4 mt-4">Product Review</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/category-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                 <div>
                    <div>
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-4 mt-4">Category & Products</h2>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>
  )
}

export default Products