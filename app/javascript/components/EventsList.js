const handleUnauthorizedErrors = response => {
  const redirectUrl = response.url.split("/").pop();
  if (!response.ok && response.status !== 422) {
    if (
      response.status === 401 ||
      response.status === 406 ||
      (response.status === 404 && redirectUrl === "sign_in.json")
    ) {
      location.reload();
    }
    console.log("Throwing error", response.statusText);
    throw Error(response.statusText);
  }
  return response;
};

const onApiFailure = response => {
  toastr.error("Something went wrong, please try after sometime !");
  console.log("Error response", response);
};

import React from "react"
import PropTypes from "prop-types"
class EventsList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      events: props.events,
      fromDate: null,
      toDate: null
    };
    this.renderDateFilters = this.renderDateFilters.bind(this);
    this.handleFromDateChange = this.handleFromDateChange.bind(this);
    this.handleToDateChange = this.handleToDateChange.bind(this);
    this.fetchEvents = this.fetchEvents.bind(this);
    this.renderEventsList = this.renderEventsList.bind(this);
    this.renderEventsListData = this.renderEventsListData.bind(this);
    this.onSuccess = this.onSuccess.bind(this);
    this.onFailure = this.onFailure.bind(this);
  };

  handleFromDateChange(event) {
    this.state.setState({ fromDate: event.target.value });
  }

  handleToDateChange(event) {
    this.state.setState({ toDate: event.target.value });
  }

  fetchEvents() {
    const params = {
      from_date: this.state.fromDate,
      to_date: this.state.toDate
    }
    this.get_request(
      params,
      this.props.index_url,
      this.onSuccess,
      this.onFailure
    )
  }

  get_request(
    params,
    link,
    successCallback,
    failureCallback
  ) {
    let apiRequest = link + '?' + $.param(params);
    let header = {
      Accept: "application/json",
      "Content-Type": "application/json"
    };
    fetch(apiRequest, {
      method: 'GET',
      headers: header,
      credentials: "include"
    })
      .then(handleUnauthorizedErrors)
      .then(function(response) {
        return response.json();
      })
      .then(function(json) {
        if (json.success !== undefined) {
          json.success ? successCallback(json) : failureCallback(json);
        } else {
          successCallback(json)
        }
      })
      .catch(function(ex) {
        console.log("#service api failed", ex);
        failureCallback();
      });
  }

  onSuccess(json) {
    this.setState({ events: json.events });
  }

  onFailure() {
    this.setState({ apiResponse: 'Fetching response failed' });
  }

  renderDateFilters() {
    return (
      <div>
        <div>
          <strong>From Date</strong>&nbsp;&nbsp;
          <input
            type="date"
            id="start_date"
            name="Start Date"
            onChange={this.handleFromDateChange}
          />
        </div>
        <br />
        <div>
          <strong>To Date</strong>&nbsp;&nbsp;
          <input
            type="date"
            id="to_date"
            name="To Date"
            onChange={this.handleToDateChange}
          />
        </div>
        <br />
        <input
          className="btn btn-default"
          name="commit"
          type="submit"
          value="Submit"
          onClick={this.fetchEvents}
        />
      </div>
    );
  }

  renderEventsListData() {
    return this.state.events.map((event, index) => {
      return (
        <tr key={index}>
          <td>{event.title}</td>
          <td>{event.start_time}</td>
          <td>{event.end_time}</td>
          <td>{event.description}</td>
          <td>{event.status}</td>
        </tr>
      );
    })
  }

  renderEventsList() {
    return (
      <table className="table table-bordered">
        <tbody>
          <tr>
            <th>Title</th>
            <th>Start Time</th>
            <th>End Time</th>
            <th>Description</th>
            <th>Status</th>
          </tr>
          {this.renderEventsListData()}
        </tbody>
      </table>
    );
  }

  render() {
    return(
      <div>
        <h1>List of Events</h1>
        {this.renderDateFilters()}
        <br />
        {this.renderEventsList()}
      </div>
    );
  }
};
export default EventsList